// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IBaseNFT {
    function factoryCreatedNFTContract(string memory name_, string memory symbol_, string memory baseTokenURI, address graphAddress_) external returns(address);
}

