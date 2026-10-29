const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const solc = require('solc');

function compile() {
  const sources = Object.fromEntries(['SCSC.sol', 'STSC.sol'].map(name =>
    [name, {content: fs.readFileSync(path.join(__dirname, name), 'utf8')}]));
  const settings = {optimizer: {enabled: true, runs: 200}, evmVersion: 'paris',
    outputSelection: {'*': {'*': ['abi', 'evm.bytecode.object', 'evm.deployedBytecode.object']}}};
  const result = JSON.parse(solc.compile(JSON.stringify({language: 'Solidity', sources, settings})));
  const errors = (result.errors || []).filter(x => x.severity === 'error');
  assert.equal(errors.length, 0, errors.map(x => x.formattedMessage).join('\n'));
  const sourceHashes = Object.fromEntries(Object.entries(sources).map(([name,source]) =>
    [name,crypto.createHash('sha256').update(source.content).digest('hex')]));
  return {contracts: result.contracts, compiler: solc.version(), settings, sourceHashes, warnings: result.errors || []};
}

if (require.main === module) {
  const build = compile();
  const output = path.join(__dirname, 'artifacts'); fs.mkdirSync(output, {recursive: true});
  for (const name of ['SCSC', 'STSC']) {
    const c = build.contracts[name + '.sol'][name];
    fs.writeFileSync(path.join(output, name + '.json'), JSON.stringify({contractName: name,
      abi: c.abi, bytecode: '0x' + c.evm.bytecode.object,
      compiler: build.compiler, settings: build.settings, sources_sha256: build.sourceHashes}, null, 2));
  }
  fs.writeFileSync(path.join(output, 'warnings.json'), JSON.stringify(build.warnings, null, 2));
  console.log('Compiled SCSC and STSC with ' + build.compiler);
}
module.exports = {compile};
