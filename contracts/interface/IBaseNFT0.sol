// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IBaseNFT0 {
    function setBaseURI(string calldata _iBaseURI) external;
    function setControlAddress(address controlAddress_) external;
    function grantRole(bytes32 role, address account) external;
    function mintBase(address _to) external;
    function ownerOf(uint256 tokenId) external returns(address);
    function burn(uint256 tokenId) external;
    function burnBase(uint256 tokenId) external;
    function tokenOfOwnerByIndex(address owner, uint256 index) external returns (uint256);
    function balanceOf(address owner) external returns (uint256);
}

