// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title BulkEnsChecker
 * @dev Contract to batch query ENS token information from the ENS BaseRegistrar contract
 * ENS BaseRegistrar: 0x57f1887a8BF19b14fC0dF6Fd9B2acc9Af147eA85
 */

interface IENSBaseRegistrar {
    function ownerOf(uint256 tokenId) external view returns (address);
    function available(uint256 id) external view returns (bool);
    function nameExpires(uint256 id) external view returns (uint256);
}

contract BulkEnsChecker {
    IENSBaseRegistrar public immutable ensBaseRegistrar;
    
    /**
     * @dev Constructor to set the ENS BaseRegistrar address
     * @param _ensBaseRegistrar Address of the ENS BaseRegistrar contract
     */
    constructor(address _ensBaseRegistrar) {
        require(_ensBaseRegistrar != address(0), "Invalid ENS address");
        ensBaseRegistrar = IENSBaseRegistrar(_ensBaseRegistrar);
    }
    
    /**
     * @dev Batch query ownerOf for multiple token IDs
     * @param tokenIds Array of ENS token IDs to query
     * @return owners Array of owner addresses (zero address if not owned)
     */
    function batchOwnerOf(uint256[] calldata tokenIds) external view returns (address[] memory owners) {
        owners = new address[](tokenIds.length);
        
        for (uint256 i = 0; i < tokenIds.length; i++) {
            try ensBaseRegistrar.ownerOf(tokenIds[i]) returns (address owner) {
                owners[i] = owner;
            } catch {
                // Return zero address if token is not owned or doesn't exist
                owners[i] = address(0);
            }
        }
        
        return owners;
    }
    
    /**
     * @dev Batch query available status for multiple token IDs
     * @param tokenIds Array of ENS token IDs to query
     * @return availabilities Array of availability status
     */
    function batchAvailable(uint256[] calldata tokenIds) external view returns (bool[] memory availabilities) {
        availabilities = new bool[](tokenIds.length);
        
        for (uint256 i = 0; i < tokenIds.length; i++) {
            try ensBaseRegistrar.available(tokenIds[i]) returns (bool isAvailable) {
                availabilities[i] = isAvailable;
            } catch {
                // Return false if call fails
                availabilities[i] = false;
            }
        }
        
        return availabilities;
    }
    
    /**
     * @dev Batch query name expiration timestamps for multiple token IDs
     * @param tokenIds Array of ENS token IDs to query
     * @return expirations Array of expiration timestamps
     */
    function batchNameExpires(uint256[] calldata tokenIds) external view returns (uint256[] memory expirations) {
        expirations = new uint256[](tokenIds.length);
        
        for (uint256 i = 0; i < tokenIds.length; i++) {
            try ensBaseRegistrar.nameExpires(tokenIds[i]) returns (uint256 expiration) {
                expirations[i] = expiration;
            } catch {
                // Return 0 if call fails
                expirations[i] = 0;
            }
        }
        
        return expirations;
    }
    
    /**
     * @dev Batch query all information (owner, availability, expiration) for multiple token IDs
     * @param tokenIds Array of ENS token IDs to query
     * @return owners Array of owner addresses
     * @return availabilities Array of availability status
     * @return expirations Array of expiration timestamps
     */
    function batchGetAllInfo(uint256[] calldata tokenIds) 
        external 
        view 
        returns (
            address[] memory owners,
            bool[] memory availabilities,
            uint256[] memory expirations
        ) 
    {
        owners = new address[](tokenIds.length);
        availabilities = new bool[](tokenIds.length);
        expirations = new uint256[](tokenIds.length);
        
        for (uint256 i = 0; i < tokenIds.length; i++) {
            // Query owner
            try ensBaseRegistrar.ownerOf(tokenIds[i]) returns (address owner) {
                owners[i] = owner;
            } catch {
                owners[i] = address(0);
            }
            
            // Query availability
            try ensBaseRegistrar.available(tokenIds[i]) returns (bool isAvailable) {
                availabilities[i] = isAvailable;
            } catch {
                availabilities[i] = false;
            }
            
            // Query expiration
            try ensBaseRegistrar.nameExpires(tokenIds[i]) returns (uint256 expiration) {
                expirations[i] = expiration;
            } catch {
                expirations[i] = 0;
            }
        }
        
        return (owners, availabilities, expirations);
    }
}
