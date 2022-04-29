// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface INFTControl {

    struct NFTInfo {
        string tokenName;
        // token picture
        string tokenImg;
        uint tag;
        uint maxMintNum;
        string introduce;
        string attrDescrip;
    }

    function NFTMintBatch(address NFTAddress, address _to, uint _num) external;
    function getNFTContractInfo(address addr_) external returns (NFTInfo memory iNFTInfo);
    function issueNumber(address addr_) external returns (uint);
    function NFTCreatorAddress(address addr_) external returns (address);
    function createNFTContract(string[] memory param0, uint[] memory param1, address graphSqlAddress_) external returns(address);
    function setInBoxNum(address address_, uint num_) external;
}
