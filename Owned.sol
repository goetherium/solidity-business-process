// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0 <0.9.0;

contract Owned {
    address owner;
    constructor() {
        owner = msg.sender;
    }

    // This contract only defines a modifier 
    // that will be used in derived contracts.
    modifier onlyOwner {
        require(
            msg.sender == owner,
            "Only owner can call this function"
        );
        _;
    }
}
