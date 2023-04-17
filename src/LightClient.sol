// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./IHeader.sol";
import "./Updater.sol";

/**
 * @title Light client contract
 * @notice This contract verify the proofs headers of the counterparty chain
 */
contract LightClient {
    Updater updater;
    constructor() public {
    }

    function setUpdater(address updaterAddress) public {
        updater = Updater(updaterAddress);
    }

    /**
    @dev only the updater can continue
    */
    modifier onlyUpdater(){
        require(msg.sender == address(updater));
        _;
    }

    /**
    @notice verify the given proof
    @dev mock verifier
    @param proof for the block header to be verified
    */
    function verifyProof(bytes memory proof) external returns (bool){
        return true;
    }
}
