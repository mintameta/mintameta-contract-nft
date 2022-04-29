// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "hardhat/console.sol";

/*
* Store attribute values for advanced NFT
*/
// name=NFTAttr.sol npm run build
contract NFTAttr is AccessControl {
    bytes32 public constant GLOBAL_ROLE = "GLOBAL_ROLE";

    mapping(address => attrInfo0[]) public attr0;

    struct attrInfo0 {
        string attrName1;
        string attrNum;
        uint attrImg;
        attrInfo1[] attr1;
    }

    struct attrInfo1 {
        string attrName;
        uint[] attrScopeInt;
        string[] attrScopeString;
        uint attrUint;
        string attrString;
    }

    modifier auth(bytes32 iRole) {
        require(hasRole(iRole, msg.sender), "Permission denied");
        _;
    }

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(GLOBAL_ROLE, msg.sender);
    }

    function add(uint[] memory param2, uint[] memory param3, string[] memory param4) public {
    }

    function addAuth(address account) public {
        grantRole(GLOBAL_ROLE, account);
    }

    function rmAuth(address account) public auth(GLOBAL_ROLE) {
        this.revokeRole(GLOBAL_ROLE, account);
    }


}
