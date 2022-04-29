// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
pragma experimental ABIEncoderV2;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract GraphSql is AccessControl {
    bytes32 public constant GLOBAL_ROLE = "GLOBAL_ROLE";

    event eCreateBoxNFTContract(address contractAddress_, string[] param0, uint[] param1, address[] param2, uint[] param3);
    event eCreateNFTContract(address contractAddress_, string[] param0, uint[] param1);
    event eOpenBox(address contractAddress_, address userAddress_);
    event eTransferNFT(address contractAddress_, address from_, address to_, uint NFTId_, uint val);
    event eNFTMintBox(address NFTAddress, address _to, uint _val);
    event eNFTBurnBox(address NFTAddress, uint tokenId);
    event eCreateLock(uint[] param0, address[] userAddress, uint256[] _amount, uint256[] _holdTime, string _name, address _tokenAddress);
    event eLockLeave(uint _index, address userAddress, uint256 collectedNum);

    event eExchange(uint indexed id_, string name_, address[] sendContractAddress_, uint[] sendContractNumber_, string img_, string introduce_, uint status_, uint type_, string[] sendContractName_);

    modifier auth(bytes32 iRrole) {
        require(hasRole(iRrole, msg.sender), "Permission denied");
        _;
    }

    constructor(){
        _setupRole(GLOBAL_ROLE, msg.sender);
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function createBoxNFTContract(address contractAddress_, string[] memory param0, uint[] memory param1, address[] memory param2, uint[] memory param3) public auth(GLOBAL_ROLE) {
        emit eCreateBoxNFTContract(contractAddress_, param0, param1, param2, param3);
    }

    function createNFTContract(address contractAddress_, string[] memory param0, uint[] memory param1) public auth(GLOBAL_ROLE) {
        emit eCreateNFTContract(contractAddress_, param0, param1);
    }

    function openBox(address contractAddress_, address userAddress_) public auth(GLOBAL_ROLE) {
        emit eOpenBox(contractAddress_, userAddress_);
    }

    function NFTMintBox(address NFTAddress, address _to, uint _val) public auth(GLOBAL_ROLE) {
        emit eNFTMintBox(NFTAddress, _to, _val);
    }

    function NFTBurnBox(address NFTAddress, uint tokenId) public auth(GLOBAL_ROLE) {
        emit eNFTBurnBox(NFTAddress, tokenId);
    }

    function transferNFT(address contractAddress_, address from_, address to_, uint NFTId_, uint val) public auth(GLOBAL_ROLE) {
        emit eTransferNFT(contractAddress_, from_, to_, NFTId_, val);
    }

    function createLock(uint[] calldata param0, address[] calldata userAddress, uint256[] calldata _amount, uint256[] calldata _holdTime, string calldata _name, address _tokenAddress) public auth(GLOBAL_ROLE) {
        emit eCreateLock(param0, userAddress, _amount, _holdTime, _name, _tokenAddress);
    }

    function lockLeave(uint _index, address userAddress, uint256 collectedNum) public auth(GLOBAL_ROLE) {
        emit eLockLeave(_index, userAddress, collectedNum);
    }

    // old
    function exchange(uint id_, string calldata name_, address[] memory sendContractAddress_, uint[] memory sendContractNumber_, string calldata img_, string calldata introduce_, uint status_, uint type_, string[] memory sendContractName_) public auth(GLOBAL_ROLE) {
        emit eExchange(id_, name_, sendContractAddress_, sendContractNumber_, img_, introduce_, status_, type_, sendContractName_);
    }

    function addRole(address address_) public auth(DEFAULT_ADMIN_ROLE) {
        grantRole(GLOBAL_ROLE, address_);
        grantRole(DEFAULT_ADMIN_ROLE, address_);
    }

    function rmRole(address account) public auth(GLOBAL_ROLE) {
        this.revokeRole(GLOBAL_ROLE, account);
    }


}
