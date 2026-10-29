const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const assert = require('node:assert/strict');
process.env.UWS_USE_FALLBACK ||= '1';
const ganache = require('ganache');
const {BrowserProvider, Wallet, ContractFactory, getBytes} = require('ethers');
const {compile} = require('./compile.cjs');
const {ServiceApplication, signRequest, receive} = require('./application.cjs');

async function main() {
  const build = compile(), artifact = build.contracts['STSC.sol'].STSC;
  const engine = ganache.provider({logging: {quiet: true}, chain: {chainId: 1337, hardfork: 'shanghai'},
    miner: {blockGasLimit: 30000000}, wallet: {totalAccounts: 10}});
  const provider = new BrowserProvider(engine, undefined, {cacheTimeout: -1}); provider.pollingInterval = 10;
  const wallets = Object.values(engine.getInitialAccounts()).map(x => new Wallet(x.secretKey, provider));
  const [owner, operator, ldOne, ldTwo] = wallets;
  const output = path.join(__dirname, 'results', 'workflow'); fs.mkdirSync(output, {recursive: true});
  const runtime = fs.mkdtempSync(path.join(output, 'runtime-'));
  const contentRoot = path.join(runtime, 'content'); fs.mkdirSync(contentRoot);
  const payload = Buffer.from('B-HLW authenticated payload fixture\n'); fs.writeFileSync(path.join(contentRoot, 'example.bin'), payload);
  const checks = [];
  const check = label => checks.push({check: label, passed: true});
  const rejects = async (operation, expression, label) => {await assert.rejects(operation, expression); check(label);};
  const mine = async n => {for (let i = 0; i < n; i++) await engine.request({method: 'evm_mine', params: []});};
  try {
    const contract = await new ContractFactory(artifact.abi, artifact.evm.bytecode.object, owner).deploy();
    await contract.waitForDeployment();
    const find = 'findPair(int256[],int256[3][],string[])';
    assert.equal(Number(await contract.getLDCount()), 9); assert.equal(Number(await contract.getUserCount()), 20);
    check('constructor retains nine LDs and twenty users');
    await rejects(() => contract[find].staticCall([1], [[2,2,1]], ['example.bin']), /AP approval required/, 'AP participation is required');
    await rejects(() => contract.connect(operator).setUserSigner.staticCall(1, operator.address), /Only owner/, 'only owner enrolls user signers');
    await (await contract.setOperator(operator.address, true)).wait();
    for (const actor of [owner, operator, ldOne, ldTwo, ...wallets.slice(4,9)])
      await (await contract.connect(actor).approveParticipation(true)).wait();
    for (let ld = 1; ld <= 9; ld++) await (await contract.setLDController(ld, ld === 2 ? ldTwo.address : ldOne.address)).wait();
    for (let uid = 1; uid <= 5; uid++) await (await contract.setUserSigner(uid, wallets[uid+3].address)).wait();
    check('individual user, AP and LD approvals are signed and recorded separately from deployment');
    await rejects(() => contract.connect(operator)['findPair(int256[],int256[3][])'].staticCall([1], [[2,2,1]]), /Use filename/, 'filename requirement cannot be bypassed through inherited ABI');
    await rejects(() => contract.connect(operator)[find].staticCall([1], [[2,2,1]], []), /Filename length mismatch/, 'mismatched filename arrays rejected');
    await rejects(() => contract.connect(operator)[find].staticCall([1], [[2,2,1]], ['']), /Invalid filename/, 'empty filenames rejected');
    await (await contract.connect(wallets[4]).approveParticipation(false)).wait();
    await rejects(() => contract.connect(operator)[find].staticCall([1], [[2,2,1]], ['example.bin']), /User approval required/, 'withdrawn user approval blocks assignment');
    await (await contract.connect(wallets[4]).approveParticipation(true)).wait();
    const chainId = String((await provider.getNetwork()).chainId), address = await contract.getAddress();
    const keys = Object.fromEntries([1,2,3,4,5].map(i => [i, crypto.randomBytes(32)]));
    const acl = Object.fromEntries([1,2,3,4,5].map(i => [i, ['example.bin']]));
    const options = {contract: contract.connect(operator), stateFile: path.join(runtime, 'queue.json'), contentRoot, acl, keys, confirmations: 4};
    let app = new ServiceApplication(options);
    async function request(uid, nonce, position = [2,2,1], extra = {}) {
      return signRequest(wallets[uid+3], {chainId, contract: address, userId: uid,
        position, filename: 'example.bin', nonce, expires: 130, ...extra});
    }
    const original = await request(1, 0);
    await rejects(() => app.submitBatch([{...original, position: [5,2,1]}], 100), /Invalid request signature/, 'request coordinates are signature-bound');
    await rejects(async () => app.submitBatch([await request(1, 0, [2,2,1], {chainId: '1'})], 100), /Wrong chain/, 'cross-chain replay rejected');
    await rejects(async () => app.submitBatch([await request(1, 0, [2,2,1], {expires: 99})], 100), /Expired request/, 'expired requests rejected');
    await rejects(async () => app.submitBatch([await request(1, 0, [2,2,1], {filename: '../secret.bin'})], 100), /Content authorization/, 'content ACL rejects unauthorized filenames');
    await rejects(() => app.submitBatch([original, original], 100), /Duplicate user ID/, 'duplicate requests rejected before nonce consumption');
    const requests = await Promise.all([request(1,0), request(2,0), request(3,0,[5,2,1]), request(4,0), request(5,0)]);
    const decisions = await app.submitBatch(requests, 100);
    assert.deepEqual(decisions.map(x => x.reason), ['accepted','accepted','accepted','accepted','capacity']);
    assert.deepEqual(app.state.queues[1].map(x => x.userId), [1,2,4]);
    assert.deepEqual(app.state.queues[2].map(x => x.userId), [3]);
    check('five-user example rejects User 5 at capacity three in the application');
    const batch = Number(await contract.batchId());
    assert.equal(await contract.requestedFiles(batch,1), 'example.bin');
    const transaction = await provider.getTransaction(decisions[0].transactionHash);
    const parsed = contract.interface.parseTransaction({data: transaction.data});
    assert.deepEqual(Array.from(parsed.args[2]), Array(5).fill('example.bin'));
    const calldataBytes = getBytes(transaction.data).length;
    assert(calldataBytes > 132 + 128 * 5); check('requested filenames are present in actual transaction calldata and stored metadata');
    assert.equal(await app.serveNext(1, packet => receive(packet, keys[1]).ack), false);
    check('payload delivery waits for four subsequent blocks');
    await mine(4);
    await rejects(() => app.serveNext(1, () => '0'.repeat(64)), /Invalid ACK/, 'forged ACK preserves the FIFO head');
    await rejects(() => app.serveNext(1, packet => {
      const altered = {...packet, ciphertext: Buffer.from(packet.ciphertext)}; altered.ciphertext[0] ^= 1;
      return receive(altered, keys[1]).ack;
    }), /authenticate|auth|Unsupported/i, 'altered ciphertext fails AES-GCM authentication');
    assert.equal(app.state.queues[1][0].userId, 1);
    let release;
    const gate = new Promise(resolve => {release = resolve;});
    const firstDelivery = app.serveNext(1, async packet => {await gate; const r = receive(packet,keys[1]); assert.deepEqual(r.plaintext,payload); return r.ack;});
    await rejects(() => app.serveNext(1, packet => receive(packet,keys[1]).ack), /Finish the pending batch/, 'concurrent delivery cannot consume two FIFO entries');
    release(); assert(await firstDelivery);
    check('authenticated payload and ACK complete exactly the FIFO head');
    app = new ServiceApplication(options);
    assert.deepEqual(app.state.queues[1].map(x => x.userId), [2,4]);
    assert.equal(app.state.queues[1][0].signedRequest.signature,requests[1].signature);
    check('signed control-request evidence retained with the durable queue');
    await app.submitBatch([await request(5,1)], 100);
    assert.deepEqual(Array.from((await contract.getServicelistForLD(1)).allocatedUserIds, Number), [5]);
    assert.deepEqual(app.state.queues[1].map(x => x.userId), [2,4,5]);
    assert.equal(await contract.requestedFiles(batch,1), 'example.bin');
    check('persistent FIFO and filename history survive process restart and contract batch reset');
    await rejects(async () => app.submitBatch([await request(5,1)],100), /Replayed nonce/, 'durable nonce state rejects replay after restart');
    const capacity = await app.submitBatch([await request(1,1,[3,3,1])],100);
    assert.equal(capacity[0].reason,'capacity'); check('occupancy check precedes optical coverage');
    await mine(4);
    const order = [];
    await app.serveNext(1,(packet,item) => {order.push(item.userId); return receive(packet, keys[item.userId]).ack;});
    const coverage = await app.submitBatch([await request(1,2,[3,3,1])],100);
    assert.equal(coverage[0].reason,'coverage'); check('out-of-FoV requests rejected when capacity is available');
    await mine(4);
    while (await app.serveNext(1,(packet,item) => {order.push(item.userId); return receive(packet,keys[item.userId]).ack;})) {}
    assert.deepEqual(order,[2,4,5]); check('FIFO service order retained across multiple batches');
    await (await contract.connect(ldTwo).approveParticipation(false)).wait();
    await rejects(() => app.serveNext(2,packet => receive(packet,keys[3]).ack), /Participation withdrawn/, 'LD revocation blocks pending content delivery');
    await (await contract.connect(ldTwo).approveParticipation(true)).wait();
    assert(await app.serveNext(2,packet => receive(packet,keys[3]).ack));
    // Interrupt between mined transaction and queue commit, then recover receipt.
    await rejects(async () => app.submitBatch([await request(1,3)],100), /Request allowance exceeded/, 'per-user request allowance enforced');
    app._recoverPending = async () => {throw Error('Injected restart point');};
    await rejects(async () => app.submitBatch([await request(1,3)],111), /Injected restart point/, 'transaction-to-queue interruption retained in durable journal');
    app = new ServiceApplication(options); await app.recoverPending();
    assert.equal(app.state.queues[1].length,1); assert.deepEqual(await app.recoverPending(),[]);
    check('receipt recovery enqueues a committed assignment exactly once');
    const report = {passed: true, checks, compiler: build.compiler, chainId: 1337,
      filename_batch_calldata_bytes: calldataBytes, runtime: process.version,
      execution: 'local in-memory EVM and local payload transport callback',
      payload_transport_hardware_tested: false, public_testnet_deployed: false};
    fs.writeFileSync(path.join(output,'verification.json'),JSON.stringify(report,null,2));
    console.log(JSON.stringify({passed:true,workflow_checks:checks.length,filename_batch_calldata_bytes:calldataBytes}));
  } finally {provider.destroy(); await engine.disconnect();}
}
main().catch(error => {console.error(error); process.exitCode = 1;});
