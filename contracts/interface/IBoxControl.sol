// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IBoxControl {
//    mapping(address => NFTInfo) public attrKey;
//    address[] public createdContractArr;
//    mapping(address => address) public NFTCreatorAddress;
//    mapping(address => address[]) public NFTCreatedArr;
//    mapping(address => uint) public issueNumber;
//
    struct NFTInfo {
        string tokenName;
        string tokenImg;
        uint price;
        uint startTime;
        uint endTime;
        string introduce;
        address[] NFTAddressArr;
        uint[] NFTTotal;
        uint[] NFTOpened;
    }

    function NFTMint(address NFTAddress, address _to, uint _val) external;
    function getNFTContractInfo(address addr_) external returns (NFTInfo memory iNFTInfo);
    function issueNumber(address addr_) external returns (uint);
    function createNFTContract(string[] memory param0, uint[] memory param1, address[] memory param2, uint[] memory param3, address graphSqlAddress_) external returns(address);
}
