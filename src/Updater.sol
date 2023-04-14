// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./IUpdater.sol";

/**
 * @title Updater contract
 * @dev This contract exposes two main functions, add the header to the list of verified header, get a specified header
 */
contract Updater {


    address relayer;
    address owner;
    uint public lastHeight;
    mapping(uint => IUpdater.BlockHeader) public verifiedHeaders;

    constructor(address relayerAddress, IUpdater.BlockHeader memory genesis) public {
        relayer = relayerAddress;
        owner = msg.sender;
        verifiedHeaders[genesis.height] = genesis;
        lastHeight = 0;
    }

    /**
    @dev only the relayer can continue
    */
    modifier onlyRelayer(){
        require(msg.sender == relayer);
        _;
    }

    /**
    @notice Append the header to the list of verified header after verifying the proof.
    @param proof the validity proof of the block header
    @param blkHr the block header to append
    @param blkHrmin the parent block header
    */
    function headerUpdate(bytes memory proof, IUpdater.BlockHeader memory blkHr, IUpdater.BlockHeader memory blkHrmin) public onlyRelayer {
        require(verifiedHeaders[blkHrmin.height].height == blkHrmin.height, "no block header parent known");
        require(verifiedHeaders[blkHr.height].height == blkHr.height, "a header with this height already exists");
        compareBlkHrs(blkHrmin, verifiedHeaders[blkHrmin.height]);
        bool result = verifyProof(proof);
        require(result, "Proof cannot be verified");
        verifiedHeaders[blkHr.height] = blkHr;
        lastHeight = blkHr.height;
    }

    /**
    @notice verify the given proof
    @dev mock verifier
    @param proof for the block header to be verified
    */
    function verifyProof(bytes memory proof) internal returns (bool){
        return true;
    }

    /**
    @dev compare two block headers
    @dev TODO more efficient/elegant way to compare structs in solidity
    */
    function compareBlkHrs(IUpdater.BlockHeader memory blk1, IUpdater.BlockHeader memory blk2) internal returns (bool){
        require(keccak256(abi.encodePacked(blk1.validators)) == keccak256(abi.encodePacked(blk2.validators)), "validators");
        require(blk1.height == blk2.height, "validators");
        // keccak256(abi.encodePacked(blk1.height, keccak256(blk1.validators));
    }

    /**
    @notice Get header from the verified headers list
    @param t height of the header to look for
    */
    function getHeader(uint t) public returns (IUpdater.BlockHeader memory){
        require(verifiedHeaders[t].height == t, "no header verifier for this height, wait a bit");
        return verifiedHeaders[t];
    }
}
