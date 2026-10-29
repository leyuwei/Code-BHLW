const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const assert = require('node:assert/strict');
const {AbiCoder, keccak256, toUtf8Bytes, getBytes, verifyMessage} = require('ethers');

function requestDigest(request) {
  return keccak256(AbiCoder.defaultAbiCoder().encode(
    ['uint256', 'address', 'int256', 'int256[3]', 'bytes32', 'uint256', 'uint256'],
    [request.chainId, request.contract, request.userId, request.position,
      keccak256(toUtf8Bytes(request.filename)), request.nonce, request.expires]));
}

async function signRequest(wallet, request) {
  return {...request, signature: await wallet.signMessage(getBytes(requestDigest(request)))};
}

const digest = data => crypto.createHash('sha256').update(data).digest('hex');
const acknowledgment = (id, hash, key) => crypto.createHmac('sha256', key).update(id + ':' + hash).digest('hex');

class ServiceApplication {
  constructor({contract, stateFile, contentRoot, acl, keys, confirmations = 0, capacity = 3,
    allowance = 3, windowSeconds = 10}) {
    assert(Number.isInteger(confirmations) && confirmations >= 0);
    assert(Number.isInteger(capacity) && capacity > 0);
    assert(Number.isInteger(allowance) && allowance > 0 && windowSeconds > 0);
    this.contract = contract; this.provider = contract.runner.provider;
    this.stateFile = path.resolve(stateFile); this.contentRoot = fs.realpathSync(contentRoot);
    this.acl = acl; this.keys = keys; this.confirmations = confirmations;
    this.capacity = capacity; this.allowance = allowance; this.windowSeconds = windowSeconds;
    this.state = fs.existsSync(this.stateFile) ? JSON.parse(fs.readFileSync(this.stateFile, 'utf8')) :
      {version: 1, nonces: {}, arrivals: {}, queues: {}, outcomes: [], pending: null};
    assert.equal(this.state.version, 1); this.busy = false;
  }

  save() {
    fs.mkdirSync(path.dirname(this.stateFile), {recursive: true});
    const temporary = this.stateFile + '.tmp';
    fs.writeFileSync(temporary, JSON.stringify(this.state, null, 2), {mode: 0o600});
    fs.renameSync(temporary, this.stateFile);
  }

  contentPath(userId, filename) {
    assert(typeof filename === 'string' && filename.length > 0 && Buffer.byteLength(filename) <= 255, 'Invalid filename');
    assert((this.acl[String(userId)] || []).includes(filename), 'Content authorization failed');
    const full = fs.realpathSync(path.resolve(this.contentRoot, filename));
    assert(full.startsWith(this.contentRoot + path.sep) && fs.statSync(full).isFile(), 'Content path escapes root');
    return full;
  }

  async authenticate(request, now) {
    assert(Number.isSafeInteger(now), 'Time must be integer seconds');
    assert(Number.isSafeInteger(request.userId) && request.userId > 0, 'Invalid user ID');
    assert(Array.isArray(request.position) && request.position.length === 3 && request.position.every(
      (v, i) => Number.isSafeInteger(v) && v >= 0 && v <= [10, 10, 3][i]), 'Invalid position');
    assert(request.position[2] === 1, 'The example uses receiver height 1 m');
    assert(String(request.chainId) === String((await this.provider.getNetwork()).chainId), 'Wrong chain');
    assert(request.contract.toLowerCase() === (await this.contract.getAddress()).toLowerCase(), 'Wrong contract');
    assert(Number.isSafeInteger(request.nonce) && request.nonce >= 0 &&
      request.nonce > (this.state.nonces[request.userId] ?? -1), 'Replayed nonce');
    assert(Number.isSafeInteger(request.expires) && request.expires >= now && request.expires <= now + 30, 'Expired request');
    const signer = await this.contract.userSigner(request.userId);
    assert.equal(verifyMessage(getBytes(requestDigest(request)), request.signature).toLowerCase(), signer.toLowerCase(), 'Invalid request signature');
    assert(await this.contract.participantApproval(signer), 'User participation withdrawn');
    this.contentPath(request.userId, request.filename);
    assert(Buffer.isBuffer(this.keys[request.userId]) && this.keys[request.userId].length === 32, 'Missing content key');
    assert(!Object.values(this.state.queues).flat().some(x => x.userId === request.userId), 'User has an outstanding request');
    const recent = (this.state.arrivals[request.userId] || []).filter(x => x > now - this.windowSeconds);
    assert(recent.length < this.allowance, 'Request allowance exceeded');
    return recent;
  }

  async submitBatch(requests, now) {
    assert(!this.busy && !this.state.pending, 'Finish the pending batch first');
    assert(requests.length > 0 && requests.length <= 20, 'Invalid batch size');
    assert.equal(new Set(requests.map(x => x.userId)).size, requests.length, 'Duplicate user ID');
    this.busy = true;
    try {
      // Validate all requests before consuming nonces or submitting a transaction.
      const recent = [];
      for (const request of requests) recent.push(await this.authenticate(request, now));
      requests.forEach((r, i) => {this.state.nonces[r.userId] = r.nonce; this.state.arrivals[r.userId] = [...recent[i], now];});
      this.state.pending = {requests, txHash: null}; this.save();
      const tx = await this.contract['findPair(int256[],int256[3][],string[])'](
        requests.map(x => x.userId), requests.map(x => x.position), requests.map(x => x.filename));
      this.state.pending.txHash = tx.hash; this.save();
      await tx.wait();
      return await this._recoverPending();
    } catch (error) {
      // A submission rejected before broadcast cannot produce assignments.
      if (this.state.pending && !this.state.pending.txHash) {this.state.pending = null; this.save();}
      throw error;
    } finally {this.busy = false;}
  }

  async recoverPending() {
    assert(!this.busy, 'Another application operation is in progress');
    this.busy = true;
    try {return await this._recoverPending();} finally {this.busy = false;}
  }

  async _recoverPending() {
    const pending = this.state.pending;
    if (!pending) return [];
    assert(pending.txHash, 'A submission interrupted before broadcast must be resubmitted with a fresh nonce');
    const receipt = await this.provider.getTransactionReceipt(pending.txHash);
    assert(receipt, 'Assignment transaction is still pending');
    if (receipt.status !== 1) {this.state.pending = null; this.save(); throw Error('Assignment transaction reverted');}
    const event = receipt.logs.map(x => {try {return this.contract.interface.parseLog(x);} catch {return null;}})
      .find(x => x && x.name === 'BatchRecorded');
    assert(event, 'Missing assignment batch receipt');
    const batch = Number(event.args.batch);
    if (!pending.decisions) {
      const occupancy = Object.fromEntries(Object.entries(this.state.queues).map(([ld, q]) => [ld, q.length]));
      pending.decisions = [];
      for (const request of pending.requests) {
        const ld = Number(await this.contract.assignedLD(batch, request.userId)); assert(ld > 0);
        const coordinates = [2 + 3 * ((ld - 1) % 3), 2 + 3 * Math.floor((ld - 1) / 3), 3];
        const distance = Math.hypot(...request.position.map((x, i) => x - coordinates[i]));
        const reason = (occupancy[ld] || 0) >= this.capacity ? 'capacity' :
          (coordinates[2] - request.position[2]) / distance < Math.cos(Math.PI / 6) ? 'coverage' : 'accepted';
        if (reason === 'accepted') occupancy[ld] = (occupancy[ld] || 0) + 1;
        pending.decisions.push({id: batch + ':' + request.userId, userId: request.userId,
          ld, filename: request.filename, signedRequest: request, reason, transactionHash: receipt.hash,
          blockNumber: receipt.blockNumber, blockHash: receipt.blockHash});
      }
      this.save();
    }
    // Supplementary E places persistent queues/admission in the application.
    // Consume the assignment receipt once; contract batch storage can reset.
    for (const item of pending.decisions) {
      if (item.reason === 'accepted') (this.state.queues[item.ld] ||= []).push(item);
      this.state.outcomes.push(item);
    }
    const result = pending.decisions;
    this.state.pending = null; this.save(); return result;
  }

  async serveNext(ld, receiver) {
    assert(!this.busy && !this.state.pending, 'Finish the pending batch first');
    this.busy = true;
    try {
      const item = (this.state.queues[ld] || [])[0]; if (!item) return false;
      const block = await this.provider.getBlock(item.blockNumber);
      assert(block && block.hash === item.blockHash, 'Assignment block changed');
      if (await this.provider.getBlockNumber() < item.blockNumber + this.confirmations) return false;
      const signer = await this.contract.userSigner(item.userId);
      const controller = await this.contract.ldController(ld);
      assert(await this.contract.participantApproval(signer) && await this.contract.participantApproval(controller), 'Participation withdrawn');
      const plaintext = fs.readFileSync(this.contentPath(item.userId, item.filename));
      const key = this.keys[item.userId], iv = crypto.randomBytes(12);
      const cipher = crypto.createCipheriv('aes-256-gcm', key, iv); cipher.setAAD(Buffer.from(item.id));
      const packet = {id: item.id, ciphertext: Buffer.concat([cipher.update(plaintext), cipher.final()]),
        iv, tag: cipher.getAuthTag()};
      const ack = await receiver(packet, item);
      const expected = acknowledgment(item.id, digest(plaintext), key);
      assert(typeof ack === 'string' && /^[0-9a-f]{64}$/i.test(ack) &&
        crypto.timingSafeEqual(Buffer.from(ack, 'hex'), Buffer.from(expected, 'hex')), 'Invalid ACK');
      this.state.queues[ld].shift(); this.save(); return true;
    } finally {this.busy = false;}
  }
}

function receive(packet, key) {
  const cipher = crypto.createDecipheriv('aes-256-gcm', key, packet.iv);
  cipher.setAAD(Buffer.from(packet.id)); cipher.setAuthTag(packet.tag);
  const plaintext = Buffer.concat([cipher.update(packet.ciphertext), cipher.final()]);
  return {plaintext, ack: acknowledgment(packet.id, digest(plaintext), key)};
}

module.exports = {ServiceApplication, signRequest, requestDigest, receive};
