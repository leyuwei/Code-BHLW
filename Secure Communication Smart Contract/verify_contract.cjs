// Local, in-memory execution only. No RPC listener, external chain, or real keys.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const solc = require('solc');
process.env.UWS_USE_FALLBACK ||= '1';
const ganache = require('ganache');
const {BrowserProvider, ContractFactory, getBytes} = require('ethers');
const root = __dirname;
const output = path.join(root, 'results', 'contract');
fs.mkdirSync(output, {recursive:true});
const checks = [];
const rows = [];

function compile(file) {
  const text = fs.readFileSync(file, 'utf8');
  const settings = {optimizer:{enabled:true,runs:200}, evmVersion:'paris',
    outputSelection:{'*':{'*':['abi','evm.bytecode.object','evm.deployedBytecode.object']}}};
  const result = JSON.parse(solc.compile(JSON.stringify({language:'Solidity',sources:{'SCSC.sol':{content:text}},settings})));
  const errors = (result.errors || []).filter(e => e.severity === 'error');
  assert.equal(errors.length,0,errors.map(e=>e.formattedMessage).join('\n'));
  const contract = result.contracts['SCSC.sol'].SCSC;
  return {abi:contract.abi,bytecode:contract.evm.bytecode.object,settings,
    source_sha256:crypto.createHash('sha256').update(text).digest('hex'),warnings:result.errors || []};
}
async function expectRevert(contract, method, args, label) {
  let rejected = false;
  try {await contract[method].staticCall(...args);} catch(e) {rejected = true;}
  assert(rejected,label);
  // Force a real local transaction as well; a preflight simulation alone is
  // insufficient evidence that an included failed call leaves state unchanged.
  let transactionReverted=false;
  try {const tx=await contract[method](...args,{gasLimit:8000000});await tx.wait();}
  catch(e) {transactionReverted=!!e.receipt && e.receipt.status===0;}
  assert(transactionReverted,label+' (included transaction)');
  checks.push({check:label,passed:true});
}
async function lists(contract) {
  const result = [];
  for(let ld=1;ld<=9;ld++) {
    const s = await contract.getServicelistForLD(ld);
    result.push(Array.from(s.allocatedUserIds,Number));
  }
  return result;
}
async function main() {
  const legacy=compile(path.join(root,'originals','SCSC.sol'));
  const revised=compile(path.join(root,'SCSC.sol'));
  const engine=ganache.provider({logging:{quiet:true},chain:{chainId:1337,hardfork:'shanghai'},
    miner:{blockGasLimit:30000000},wallet:{totalAccounts:3}});
  const provider=new BrowserProvider(engine,undefined,{cacheTimeout:-1});
  provider.pollingInterval=10;
  const owner=await provider.getSigner(0), outsider=await provider.getSigner(1), operator=await provider.getSigner(2);
  async function deploy(build) {
    const c=await new ContractFactory(build.abi,build.bytecode,owner).deploy();
    await c.waitForDeployment();return c;
  }
  try {
    const old=await deploy(legacy), current=await deploy(revised);
    // Reproduce the actual legacy failure, then run precisely the same caller/input.
    await (await old.connect(outsider).findPair([1],[[2,2,1]])).wait();
    assert.deepEqual((await lists(old))[0],[1]);
    checks.push({check:'legacy unauthorized caller changes allocation',passed:true,legacy_failure_reproduced:true});
    const stateBefore=await lists(current);
    await expectRevert(current.connect(outsider),'findPair',[[1],[[2,2,1]]],'revised unauthorized operator rejected');
    assert.deepEqual(await lists(current),stateBefore);
    await expectRevert(current.connect(outsider),'setOperator',[await outsider.getAddress(),true],'non-owner cannot grant a role');
    await (await current.setOperator(await operator.getAddress(),true)).wait();
    const receipt=await (await current.connect(operator).findPair([1],[[2,2,1]])).wait();
    assert.equal(receipt.logs.length,2);
    const parsed=receipt.logs.map(x=>current.interface.parseLog(x));
    const event=parsed.find(x=>x.name==='BatchRecorded');
    assert.equal(event.name,'BatchRecorded');assert.equal(Number(event.args.requests),1);
    checks.push({check:'authorized operator executes and emits batch notification',passed:true});
    await (await current.setOperator(await operator.getAddress(),false)).wait();
    await expectRevert(current.connect(operator),'findPair',[[1],[[2,2,1]]],'revoked operator rejected');
    await expectRevert(current,'findPair',[[],[]],'empty batch rejected');
    await expectRevert(current,'findPair',[[1],[[2,2,1],[5,5,1]]],'unequal arrays rejected, including trailing coordinates');
    await expectRevert(current,'findPair',[[99],[[2,2,1]]],'unregistered identity rejected');
    await expectRevert(current,'findPair',[[1,1],[[2,2,1],[5,5,1]]],'duplicate identity in a batch rejected');
    await expectRevert(current,'findPair',[[1],[[11,2,1]]],'outside-room input rejected before arithmetic');
    await expectRevert(current,'findPair',[[1],[[2,2,2n**255n-1n]]],'overflow-sized input rejected');
    assert.deepEqual(await lists(current),[[1],[],[],[],[],[],[],[],[]]);
    checks.push({check:'all included failed revised calls preserve the previous allocation',passed:true});
    const coords=Array.from({length:20},(_,i)=>[i%10,Math.floor(i/2)%10,1]);
    const ids=Array.from({length:20},(_,i)=>i+1);
    await (await old.findPair(ids,coords)).wait();
    await (await current.findPair(ids,coords)).wait();
    const got=await lists(current);assert.deepEqual(got,await lists(old));
    const ldcoords=Array.from({length:9},(_,i)=>[2+3*(i%3),2+3*Math.floor(i/3),3]);
    coords.forEach((p,i)=>{
      const distances=ldcoords.map(q=>q.reduce((sum,x,j)=>sum+(x-p[j])**2,0));
      assert(got[distances.indexOf(Math.min(...distances))].includes(i+1));
    });
    checks.push({check:'original and revised preserve all 20 nearest-LD decisions',passed:true});
    await (await current.findPair([2],[[8,8,1]])).wait();
    assert.deepEqual(await lists(current),[[],[],[],[],[],[],[],[],[2]]);
    checks.push({check:'batch reset retained; no persistent queue is claimed',passed:true});
    const priorAssignment=parsed.find(x=>x.name==='AssignmentRecorded');
    assert.equal(Number(priorAssignment.args.userId),1);assert.equal(Number(priorAssignment.args.LDId),1);
    checks.push({check:'assignment receipts retain earlier batch outcomes after a later storage reset',passed:true});
    const batch=JSON.parse(fs.readFileSync(path.join(root,'../verification/results/policy/batch_to_contract.json'),'utf8'));
    await (await current.findPair(batch.ids,batch.coordinates)).wait();
    const bridged=await lists(current);assert.deepEqual(bridged[0],[1]);assert.deepEqual(bridged[8],[2]);
    checks.push({check:'AP-authenticated nonreplayed batch executes through the actual Solidity ABI',passed:true});
    // Observe a second legacy input bug directly, not just by reading its source.
    await (await old.findPair([1],[[2,2,1],[8,8,1]])).wait();
    checks.push({check:'legacy ignores extra coordinate records',passed:true,legacy_failure_reproduced:true});
    for(const [name,build] of [['original',legacy],['revised',revised]]) {
      for(const n of [1,5,10,20]) {
        const contract=await deploy(build);
        for(const lifecycle of ['fresh','repeat']) {
          const data=contract.interface.encodeFunctionData('findPair',[ids.slice(0,n),coords.slice(0,n)]);
          assert.equal(getBytes(data).length,132+128*n);
          const tx=await contract.findPair(ids.slice(0,n),coords.slice(0,n));const r=await tx.wait();
          rows.push({version:name,batch_size:n,state:lifecycle,gas:Number(r.gasUsed),
            gas_per_request:Number(r.gasUsed)/n,calldata_bytes:getBytes(data).length,block:r.blockNumber,tx_hash:r.hash});
        }
      }
    }
    checks.push({check:'measured calldata equals 132 + 128U bytes for all tested batches',passed:true});
    const summary={runtime:{node:process.version,solc:solc.version(),ganache:require('ganache/package.json').version,
      ethers:require('ethers').version,chain_id:1337,hardfork:'shanghai',gas_limit:30000000},
      compiler_settings:revised.settings,sources:{original:legacy.source_sha256,revised:revised.source_sha256},
      checks,gas:rows,limitations:['In-memory local EVM; no public Testnet deployment or consensus experiment.',
      'Operator authorization trusts the AP; it does not authenticate per-user coordinates.',
      'Public calldata still exposes IDs and coordinates. No privacy fix is inferred.',
      'Batch reset is retained; no persistent FIFO or capacity-three implementation is claimed.',
      'Gas is execution cost, not energy or a measured network throughput/finality guarantee.']};
    fs.writeFileSync(path.join(output,'verification.json'),JSON.stringify(summary,null,2));
    fs.writeFileSync(path.join(output,'gas.csv'),Object.keys(rows[0]).join(',')+'\n'+rows.map(x=>Object.values(x).join(',')).join('\n')+'\n');
    fs.writeFileSync(path.join(output,'compiler_warnings.json'),JSON.stringify({original:legacy.warnings,revised:revised.warnings},null,2));
    console.log(JSON.stringify({checks:checks.length,passed:checks.every(x=>x.passed),gas_measurements:rows.length,
      twenty_user_revised_gas:rows.find(x=>x.version==='revised'&&x.batch_size===20&&x.state==='fresh').gas}));
  } finally {provider.destroy();await engine.disconnect();}
}
main().catch(e=>{console.error(e);process.exitCode=1;});
