# BulkEnsChecker

A Solidity smart contract for batch querying ENS (Ethereum Name Service) token information from the ENS BaseRegistrar contract.

## Overview

BulkEnsChecker provides efficient batch operations to retrieve information about multiple ENS tokens in a single call, reducing the number of RPC requests needed when working with multiple ENS domains.

## Features

- **batchOwnerOf**: Query ownership of multiple ENS tokens at once
- **batchAvailable**: Check availability status for multiple ENS tokens
- **batchNameExpires**: Get expiration timestamps for multiple ENS tokens
- **batchGetAllInfo**: Get all information (owner, availability, expiration) for multiple tokens in one call

## Contract Address

The contract interacts with the ENS BaseRegistrar at: `0x57f1887a8BF19b14fC0dF6Fd9B2acc9Af147eA85`

## Usage

### Deployment

Deploy the contract with the ENS BaseRegistrar address:

```solidity
BulkEnsChecker checker = new BulkEnsChecker(0x57f1887a8BF19b14fC0dF6Fd9B2acc9Af147eA85);
```

### Batch Query Owners

```solidity
uint256[] memory tokenIds = new uint256[](3);
tokenIds[0] = 12345;
tokenIds[1] = 67890;
tokenIds[2] = 11111;

address[] memory owners = checker.batchOwnerOf(tokenIds);
// Returns array of owner addresses (zero address if not owned)
```

### Batch Check Availability

```solidity
bool[] memory availabilities = checker.batchAvailable(tokenIds);
// Returns array of boolean values indicating availability
```

### Batch Get Expiration Times

```solidity
uint256[] memory expirations = checker.batchNameExpires(tokenIds);
// Returns array of expiration timestamps
```

### Batch Get All Information

```solidity
(
    address[] memory owners,
    bool[] memory availabilities,
    uint256[] memory expirations
) = checker.batchGetAllInfo(tokenIds);
```

## Error Handling

The contract uses try-catch blocks to handle errors gracefully:
- `batchOwnerOf`: Returns zero address (0x0) for tokens that don't exist or aren't owned
- `batchAvailable`: Returns false if the query fails
- `batchNameExpires`: Returns 0 if the query fails

## Building

Compile the contract:

```bash
node compile.js
```

This will generate:
- `BulkEnsChecker.abi.json` - Contract ABI
- `BulkEnsChecker.bin` - Contract bytecode

## Contract Interface

### IENSBaseRegistrar

```solidity
interface IENSBaseRegistrar {
    function ownerOf(uint256 tokenId) external view returns (address);
    function available(uint256 id) external view returns (bool);
    function nameExpires(uint256 id) external view returns (uint256);
}
```

## License

MIT