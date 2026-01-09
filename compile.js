const solc = require('solc');
const fs = require('fs');
const path = require('path');

const contractPath = path.resolve(__dirname, 'BulkEnsChecker.sol');
const source = fs.readFileSync(contractPath, 'utf8');

const input = {
  language: 'Solidity',
  sources: {
    'BulkEnsChecker.sol': {
      content: source
    }
  },
  settings: {
    outputSelection: {
      '*': {
        '*': ['abi', 'evm.bytecode']
      }
    }
  }
};

const output = JSON.parse(solc.compile(JSON.stringify(input)));

if (output.errors) {
  let hasError = false;
  output.errors.forEach(error => {
    console.log(error.formattedMessage);
    if (error.severity === 'error') {
      hasError = true;
    }
  });
  if (hasError) {
    process.exit(1);
  }
}

const contract = output.contracts['BulkEnsChecker.sol']['BulkEnsChecker'];

// Save ABI and bytecode
fs.writeFileSync(
  path.resolve(__dirname, 'BulkEnsChecker.abi.json'),
  JSON.stringify(contract.abi, null, 2)
);

fs.writeFileSync(
  path.resolve(__dirname, 'BulkEnsChecker.bin'),
  contract.evm.bytecode.object
);

console.log('Contract compiled successfully!');
console.log('ABI saved to BulkEnsChecker.abi.json');
console.log('Bytecode saved to BulkEnsChecker.bin');
