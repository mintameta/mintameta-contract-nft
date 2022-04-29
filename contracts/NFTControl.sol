// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "hardhat/console.sol";
import "./interface/IBaseNFT.sol";
import "./interface/IBaseNFT0.sol";
import "./interface/IGraphSql.sol";

/*
* Store additional NFT information, circulation, etc.
*/
// name=NFTControl.sol npm run build
contract NFTControl is AccessControl {
    bytes32 public constant GLOBAL_ROLE = "GLOBAL_ROLE";

    // nft info
    mapping(address => NFTInfo) public attrKey;
    // Created contract address[]
    address[] public createdContractArr;
    // NFT Contract owner
    // NFT token address => NFT creator
    mapping(address => address) public NFTCreatorAddress;
    // User created NFT array
    // NFT creator => NFT token address[]
    mapping(address => address[]) public NFTCreatedArr;
    // NFT issue number
    mapping(address => uint) public issueNumber;

    string public tokenHost;

    address public baseNFTAddress;

    address public boxNFTControlAddress;

    address  public graphSqlAddress;

    uint public fee;
    address public feeAddress;

    struct NFTInfo {
        string tokenName;
        // token picture
        string tokenImg;
        uint tag;
        // 0 selfuse 1 box 2 sale
        uint nftType;
        // Maximum casting, 0 generations are unlimited
        uint maxMintNum;
        // Number of minted
        uint mintedNum;
        // Quantity in the blind box
        uint inBoxNum;
        string introduce;
        address owner_;
    }

    uint createdContractLength;

    modifier auth(bytes32 iRole) {
        require(hasRole(iRole, msg.sender), "Permission denied");
        _;
    }

    modifier checkNum(address NFTAddress) {
        if(msg.sender != boxNFTControlAddress){
            require(attrKey[NFTAddress].maxMintNum > attrKey[NFTAddress].mintedNum + attrKey[NFTAddress].inBoxNum, 'Exceed the total amount of release');
        }
        _;
    }

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(GLOBAL_ROLE, msg.sender);
    }

    function addAuth(address account) public {
        grantRole(GLOBAL_ROLE, account);
    }

    function rmAuth(address account) public auth(GLOBAL_ROLE) {
        this.revokeRole(GLOBAL_ROLE, account);
    }

    function setTokenHost(string calldata tokenHost_) public auth(GLOBAL_ROLE) {
        tokenHost = tokenHost_;
    }

    function setInBoxNum(address address_, uint num_) public auth(GLOBAL_ROLE) {
        require(attrKey[address_].maxMintNum >= attrKey[address_].mintedNum + attrKey[address_].inBoxNum + num_, 'setInBoxNum: Exceed the total amount of release');
        attrKey[address_].inBoxNum += num_;
    }

    function setBaseNFTAddress(address address_) public auth(GLOBAL_ROLE) {
        baseNFTAddress = address_;
    }

    function setBoxNFTControlAddress(address address_) public auth(GLOBAL_ROLE) {
        boxNFTControlAddress = address_;
    }

    function setGraphSqlAddress(address address_) public auth(GLOBAL_ROLE) {
        graphSqlAddress = address_;
    }

    function getCreatedContractArrLength() public view returns (uint){
        return createdContractArr.length;
    }

    function getNFTCreatedArrLength(address createdAddress) public view returns (uint){
        return NFTCreatedArr[createdAddress].length;
    }

    function setFee(uint fee_) public auth(GLOBAL_ROLE){
        fee = fee_;
    }

    function setFeeAddress(address address_) public auth(GLOBAL_ROLE){
        feeAddress = address_;
    }

    /*
    * param0 string[name_, symbol_, tokenImg_, introduce_]
    * param1 uint[type_, issueNumber, index]
    */
    function createNFTContract(string[] memory param0, uint[] memory param1) public payable returns (address){
        require(msg.value == fee, 'Handling fee error');
        address createdNFTAddress = IBaseNFT(baseNFTAddress).factoryCreatedNFTContract(param0[0], param0[1], '', graphSqlAddress);
        IBaseNFT0 NFTObj0 = IBaseNFT0(createdNFTAddress);
        string memory tokenUri = string(abi.encodePacked(tokenHost, addressToString(address(NFTObj0))));
        NFTObj0.setBaseURI(tokenUri);

        NFTInfo memory iNFTInfo;
        iNFTInfo.tokenName = param0[0];
        iNFTInfo.tokenImg = param0[2];
        iNFTInfo.nftType = param1[0];
        iNFTInfo.maxMintNum = param1[1];
        iNFTInfo.introduce = param0[3];
        iNFTInfo.owner_ = msg.sender;
        attrKey[address(NFTObj0)] = iNFTInfo;

        issueNumber[address(NFTObj0)] = param1[1];
        param1[2] = createdContractLength;
        createdContractLength++;
        NFTCreatorAddress[address(NFTObj0)] = tx.origin;
        createdContractArr.push(address(NFTObj0));
        NFTCreatedArr[tx.origin].push(address(NFTObj0));
        IGraphSql(graphSqlAddress).createNFTContract(createdNFTAddress, param0, param1);
        IGraphSql(graphSqlAddress).addRole(createdNFTAddress);
        payable(feeAddress).transfer(fee);
        return createdNFTAddress;
    }

    /*
    * param0 string[name_, symbol_, tokenImg_, introduce_, attrDescrip_]
    * param1 uint[tag1_, issueNumber_, maxMintNum_]
    * param2 uint[] attr index.
    * param3 uint[] attr value(int)
    * param4 string[] attr value(string)
    * param5 string[] attr name
    * param6 uint[] attr number
    * param7 string[] attr img
    */
//    function createNFTContractAdvanced(string[] memory param0, uint[] memory param1, uint[] memory param2, uint[] memory param3, string[] memory param4, string[] memory param5, uint[] memory param6, string[] memory param7) public auth(GLOBAL_ROLE) returns (address){
//        address createdNFTAddress = IBaseNFT(baseNFTAddress).factoryCreatedNFTContract(param0[0], param0[1], '', graphSqlAddress);
//        IBaseNFT0 NFTObj0 = IBaseNFT0(createdNFTAddress);
//        string memory tokenUri = string(abi.encodePacked(tokenHost, addressToString(address(NFTObj0))));
//        NFTObj0.setBaseURI(tokenUri);
//
//        NFTInfo memory iNFTInfo;
//        iNFTInfo.tokenName = param0[0];
//        iNFTInfo.tokenImg = param0[2];
//        iNFTInfo.tag = param1[0];
//        iNFTInfo.maxMintNum = param1[2];
//        iNFTInfo.introduce = param0[3];
//        attrKey[address(NFTObj0)] = iNFTInfo;
//
//        issueNumber[address(NFTObj0)] = param1[1];
//        NFTCreatorAddress[address(NFTObj0)] = tx.origin;
//        createdContractArr.push(address(NFTObj0));
//        NFTCreatedArr[tx.origin].push(address(NFTObj0));
//        return createdNFTAddress;
//    }

    function addressToString(address _addr) public pure returns (string memory) {
        bytes32 value = bytes32(uint256(uint160(address(_addr))));

        bytes memory alphabet = "0123456789abcdef";

        bytes memory str = new bytes(51);
        str[0] = "0";
        str[1] = "x";
        for (uint i = 0; i < 20; i++) {
            str[2 + i * 2] = alphabet[uint(uint8(value[i + 12] >> 4))];
            str[3 + i * 2] = alphabet[uint(uint8(value[i + 12] & 0x0f))];
        }
        return string(str);
    }

    function NFTMintBatch(address NFTAddress, address _to, uint _num) public{
        for (uint256 i = 0; i < _num; i++) {
            NFTMint(NFTAddress, _to);
        }
    }

    function NFTMint(address NFTAddress, address _to) private checkNum(NFTAddress) {
        require(hasRole(GLOBAL_ROLE, msg.sender) || attrKey[NFTAddress].owner_ == msg.sender, "Permission denied");
        require(boxNFTControlAddress != address(0), 'Must set the boxNFTControlAddress');
        if(msg.sender == boxNFTControlAddress) {
            attrKey[NFTAddress].inBoxNum--;
        }
        attrKey[NFTAddress].mintedNum++;
        IBaseNFT0 NFTObj0 = IBaseNFT0(NFTAddress);
        NFTObj0.mintBase(_to);
    }

    function getNFTContractInfo(address addr_) public view returns (NFTInfo memory iNFTInfo){
        iNFTInfo = attrKey[addr_];
        return iNFTInfo;
    }

    function addRole(address account) public auth(GLOBAL_ROLE){
        grantRole(GLOBAL_ROLE, account);
    }

    function rmRole(address account) public auth(GLOBAL_ROLE){
        this.revokeRole(GLOBAL_ROLE, account);
    }


}
