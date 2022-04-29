// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "hardhat/console.sol";
import "./interface/IGraphSql.sol";

contract LockPosition is AccessControl {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    bytes32 public constant GLOBAL_ROLE = keccak256("GLOBAL_ROLE");

    modifier auth(bytes32 iRrole) {
        require(hasRole(iRrole, msg.sender), "Permission denied");
        _;
    }

    address public graphSqlAddress;
    // todo set init lock days
    uint256 public lockTime = 90 * 1 days; // 90 days;

    // tokenaddress => info
    uint256 public userLockInfoLength;
    mapping(uint256 => userLockInfoSub) public userLockInfo;

    struct userLockInfoSub {
        string name_;
        address tokenAddress;
        address owner_;
        bool isLP;
        mapping(address => userInfo) userInfos;
    }

    struct userInfo {
        uint256 lockingNum;
        uint256 collectedNum;
        uint256 endTime;
        uint256 lastLockTime;
    }

    constructor(){
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(GLOBAL_ROLE, msg.sender);
    }

    function addAuth(address account) public{
        grantRole(GLOBAL_ROLE, account);
    }

    function rmAuth(address account) public auth(GLOBAL_ROLE){
        this.revokeRole(GLOBAL_ROLE, account);
    }

    function setGraphSqlAddress(address address_) public auth(GLOBAL_ROLE) {
        graphSqlAddress = address_;
    }

    /*
    * @param arr userAddress
    * @param arr _amount
    * @param arr _holdTime
    * @param _name
    * @param _tokenAddress Token that needs to be locked
    * @param isLP is lp token
    */
    function enter(address[] calldata userAddress, uint256[] calldata _amount, uint256[] calldata _holdTime, string calldata _name, address _tokenAddress, bool isLP) public{
        require(userAddress.length == _amount.length && _amount.length == _holdTime.length, 'parameter length err');
        uint totalAmount = 0;
        uint index = userLockInfoLength;
        for (uint i = 0; i < userAddress.length; i++) {
            enterSingle(userAddress[i], _amount[i], _holdTime[i], index);
            totalAmount += _amount[i];
        }
        IERC20(_tokenAddress).transferFrom(msg.sender, address(this), totalAmount);
        userLockInfo[index].name_ = _name;
        userLockInfo[index].tokenAddress = _tokenAddress;
        userLockInfo[index].owner_ = msg.sender;
        userLockInfo[index].isLP = isLP;
        userLockInfoLength++;
        uint[] memory param0 = new uint[](4);
        param0[0] = totalAmount;
        param0[1] = userAddress.length;
        param0[2] = index;
        param0[3] = block.timestamp;
        IGraphSql(graphSqlAddress).createLock(param0, userAddress, _amount, _holdTime, _name, _tokenAddress);
    }

    function enterSingle(address userAddress, uint256 _amount, uint256 _holdTime, uint256 index) private {
        userLockInfo[index].userInfos[userAddress].lockingNum = _amount;
        userLockInfo[index].userInfos[userAddress].endTime = block.timestamp + _holdTime;
    }

    function leave(uint256 _index) public {
        uint256 timeDifference = block.timestamp.sub(userLockInfo[_index].userInfos[msg.sender].lastLockTime);
        require(lockTime < timeDifference, 'Lock time is not satisfied');

        IERC20(userLockInfo[_index].tokenAddress).transfer(msg.sender, userLockInfo[_index].userInfos[msg.sender].lockingNum - userLockInfo[_index].userInfos[msg.sender].collectedNum);
        userLockInfo[_index].userInfos[msg.sender].collectedNum = userLockInfo[_index].userInfos[msg.sender].lockingNum;
        IGraphSql(graphSqlAddress).lockLeave(_index, msg.sender, userLockInfo[_index].userInfos[msg.sender].collectedNum);
    }

}
