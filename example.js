/**
 * Example usage of BulkEnsChecker contract with ethers.js
 * 
 * Prerequisites:
 * npm install ethers
 * 
 * This example shows how to interact with a deployed BulkEnsChecker contract
 */

const { ethers } = require('ethers');
const fs = require('fs');
const path = require('path');

// Load the ABI
const abi = JSON.parse(
  fs.readFileSync(path.resolve(__dirname, 'BulkEnsChecker.abi.json'), 'utf8')
);

// Configuration
const ENS_BASE_REGISTRAR = '0x57f1887a8BF19b14fC0dF6Fd9B2acc9Af147eA85';
const RPC_URL = 'https://eth-mainnet.g.alchemy.com/v2/YOUR_API_KEY'; // Replace with your RPC URL

// Example token IDs (these are hypothetical - replace with real ENS token IDs)
const exampleTokenIds = [
  // Token ID for 'example.eth' would go here
  // You can compute token ID from name: ethers.utils.id('example')
];

async function main() {
  // Connect to Ethereum
  const provider = new ethers.JsonRpcProvider(RPC_URL);
  
  // If you want to deploy the contract first
  const deployContract = async () => {
    const wallet = new ethers.Wallet('YOUR_PRIVATE_KEY', provider);
    const bytecode = fs.readFileSync(
      path.resolve(__dirname, 'BulkEnsChecker.bin'),
      'utf8'
    );
    
    const factory = new ethers.ContractFactory(abi, bytecode, wallet);
    const contract = await factory.deploy(ENS_BASE_REGISTRAR);
    await contract.waitForDeployment();
    
    console.log('BulkEnsChecker deployed to:', await contract.getAddress());
    return contract;
  };
  
  // If contract is already deployed, connect to it
  const connectToContract = (contractAddress) => {
    return new ethers.Contract(contractAddress, abi, provider);
  };
  
  // Example: Connect to an already deployed contract
  // const contract = connectToContract('0xYOUR_DEPLOYED_CONTRACT_ADDRESS');
  
  // Or deploy a new one
  // const contract = await deployContract();
  
  // Uncomment to use the examples below:
  
  /*
  // Example 1: Batch get owners
  console.log('Querying owners...');
  const owners = await contract.batchOwnerOf(exampleTokenIds);
  console.log('Owners:', owners);
  
  // Example 2: Batch check availability
  console.log('Checking availability...');
  const availabilities = await contract.batchAvailable(exampleTokenIds);
  console.log('Availabilities:', availabilities);
  
  // Example 3: Batch get expiration times
  console.log('Getting expiration times...');
  const expirations = await contract.batchNameExpires(exampleTokenIds);
  console.log('Expirations:', expirations.map(exp => new Date(Number(exp) * 1000)));
  
  // Example 4: Get all information at once
  console.log('Getting all information...');
  const [allOwners, allAvailabilities, allExpirations] = 
    await contract.batchGetAllInfo(exampleTokenIds);
  
  console.log('All Information:');
  for (let i = 0; i < exampleTokenIds.length; i++) {
    console.log(`Token ID ${exampleTokenIds[i]}:`);
    console.log(`  Owner: ${allOwners[i]}`);
    console.log(`  Available: ${allAvailabilities[i]}`);
    console.log(`  Expires: ${new Date(Number(allExpirations[i]) * 1000)}`);
  }
  */
}

// Utility function to compute ENS token ID from name
function getTokenId(name) {
  // Remove .eth if present
  const label = name.replace('.eth', '');
  return ethers.id(label);
}

// Example token ID computation
console.log('Example: Token ID for "vitalik":', getTokenId('vitalik'));

// Run the main function if this file is executed directly
if (require.main === module) {
  main().catch(console.error);
}

module.exports = { getTokenId };
