// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
pragma experimental ABIEncoderV2;


import "@openzeppelin/contracts/token/ERC721/presets/ERC721PresetMinterPauserAutoId.sol";
import "hardhat/console.sol";
import "../interface/IGraphSql.sol";

contract BaseNFT0 is ERC721PresetMinterPauserAutoId {
    bytes32 public constant GLOBAL_ROLE = "GLOBAL_ROLE";

    string public baseURI;
    address public controlAddress;
    address  public graphSqlAddress;

    uint public createdTokenLength;

    modifier auth(bytes32 iRole) {
        require(hasRole(iRole, msg.sender), "Permission denied");
        _;
    }

    constructor(string memory name_, string memory symbol_, string memory baseTokenURI, address preCreatedAddress, address graphAddress_) ERC721PresetMinterPauserAutoId(name_, symbol_, baseTokenURI){
        _setupRole(DEFAULT_ADMIN_ROLE, preCreatedAddress);
        _setupRole(GLOBAL_ROLE, preCreatedAddress);
        _setupRole(MINTER_ROLE, preCreatedAddress);
        _setupRole(PAUSER_ROLE, preCreatedAddress);
        controlAddress = preCreatedAddress;
        graphSqlAddress = graphAddress_;
    }

    function addAuth(address account) public {
        grantRole(GLOBAL_ROLE, account);
    }

    function rmAuth(address account) public auth(GLOBAL_ROLE) {
        this.revokeRole(GLOBAL_ROLE, account);
    }

    function setGraphSqlAddress(address address_) public auth(GLOBAL_ROLE) {
        graphSqlAddress = address_;
    }

    function setBaseURI(string calldata _iBaseURI) public auth(GLOBAL_ROLE) {
        baseURI = _iBaseURI;
    }

    function mintBase(address _to) public auth(GLOBAL_ROLE) {
        _mint(_to, createdTokenLength);
        createdTokenLength++;
    }

    function burnBase(uint256 _tokenId) public {
        burn(_tokenId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721PresetMinterPauserAutoId) {
        super._beforeTokenTransfer(from, to, tokenId);
        IGraphSql(graphSqlAddress).transferNFT(address(this), from, to, tokenId, 0);
    }

    function transferFrom1(
        address from,
        address to,
        uint256 tokenId,
        uint256 amount
    ) public {
        transferFrom(from, to, tokenId);
        IGraphSql(graphSqlAddress).transferNFT(address(this), from, to, tokenId, amount);
    }

    function _baseURI() internal override view returns (string memory) {
        return baseURI;
    }

    function setControlAddress(address controlAddress_) public auth(GLOBAL_ROLE) {
        controlAddress = controlAddress_;
    }

    function addRole(address account) public auth(GLOBAL_ROLE){
        grantRole(GLOBAL_ROLE, account);
    }

    function rmRole(address account) public auth(GLOBAL_ROLE){
        this.revokeRole(GLOBAL_ROLE, account);
    }

}


contract BaseNFT is AccessControl{

    function factoryCreatedNFTContract(string memory name_, string memory symbol_, string memory baseTokenURI, address graphAddress_) public returns (address){
        BaseNFT0 newAddress = new BaseNFT0(name_, symbol_, baseTokenURI, msg.sender, graphAddress_);
        return address(newAddress);
    }
}

