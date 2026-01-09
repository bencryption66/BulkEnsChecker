// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./BulkEnsChecker.sol";

/**
 * @title DeployBulkEnsChecker
 * @dev Example deployment script for BulkEnsChecker
 * 
 * Usage:
 * 1. Deploy this contract or use a deployment tool like Remix, Hardhat, or Foundry
 * 2. The BulkEnsChecker will be automatically deployed and configured with the ENS BaseRegistrar
 * 
 * ENS BaseRegistrar (Mainnet): 0x57f1887a8BF19b14fC0dF6Fd9B2acc9Af147eA85
 */
contract DeployBulkEnsChecker {
    BulkEnsChecker public bulkEnsChecker;
    
    // ENS BaseRegistrar address on Ethereum Mainnet
    address constant ENS_BASE_REGISTRAR = 0x57f1887a8BF19b14fC0dF6Fd9B2acc9Af147eA85;
    
    constructor() {
        bulkEnsChecker = new BulkEnsChecker(ENS_BASE_REGISTRAR);
    }
    
    /**
     * @dev Get the deployed BulkEnsChecker address
     */
    function getBulkEnsCheckerAddress() external view returns (address) {
        return address(bulkEnsChecker);
    }
}
