//// SPDX-License-Identifier: MIT
//pragma solidity >=0.4.22 <0.9.0;
//pragma experimental ABIEncoderV2;
//
////import "@openzeppelin/contracts/utils/math/Math.sol";
//import "@openzeppelin/contracts/utils/math/SafeMath.sol";
//import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
//
//import "../libs/Auth.sol";
//
//contract LockWarehouse is Auth {
//
//    using SafeMath for uint256;
//    using SafeERC20 for IERC20;
//
//    address private _base;
//
//    uint256 public lockTime = 90 * 1 days; // 90 days;
////    uint256 public lockTime = 10800; // 90 days;
////    uint256 public lockTime = 1200; // 10 days;
//    uint256 public totalLockVolume;
//
//    struct LockInfo {
//        uint256 lastLockTime;
//        uint256 lockVolume;
//        uint256 unlockingSpeed;
//        uint256 lockTime;
//        uint256 totalLockVolume;
//    }
//
//    struct RewardInfo {
//        uint256 unclaimed;
//        uint256 cumulative;
//    }
//
//    mapping(address => LockInfo) public userLockInfo;
//
//    mapping(address => RewardInfo) public userRewardInfo;
//
//    event AddLockVolume(address indexed user, uint256 lockVolume);
//
//    event ReceiveRewards(address indexed user, uint256 reward, uint256 cumulative);
//
//    constructor(
//        address baseAddress
//    ) public {
//        _base = baseAddress;
//    }
//
//    modifier updateUnlockRewards(address _account) {
//        uint256 reward = getUnlockRewards(_account);
//        if (reward > 0) {
//            userLockInfo[_account].lockVolume = userLockInfo[_account].lockVolume.sub(reward);
//            userRewardInfo[_account].unclaimed = userRewardInfo[_account].unclaimed.add(reward);
//            totalLockVolume = totalLockVolume.sub(reward);
//        }
//        _;
//    }
//
//    function addLockVolume(address _account, uint256 _lockVolume) public onlyOperator updateUnlockRewards(_account) {
//        require(_account != address(0), "account can not be 0x0!");
//        require(_lockVolume > 0, "Lock quantity cannot be 0!");
//
//        totalLockVolume = totalLockVolume.add(_lockVolume);
//
//        userLockInfo[_account].lastLockTime = block.timestamp;
//        userLockInfo[_account].lockVolume = userLockInfo[_account].lockVolume.add(_lockVolume);
//        userLockInfo[_account].unlockingSpeed = userLockInfo[_account].lockVolume.div(lockTime);
//
//        emit AddLockVolume(_account, _lockVolume);
//    }
//
//    function receiveRewards() public updateUnlockRewards(msg.sender) {
//        uint256 reward = userRewardInfo[msg.sender].unclaimed;
//        require(reward > 0, "No reward available!");
//
//        userLockInfo[msg.sender].lastLockTime = block.timestamp;
//
//        IERC20(_base).transfer(msg.sender, reward);
//
//        userRewardInfo[msg.sender].unclaimed = 0;
//        userRewardInfo[msg.sender].cumulative = userRewardInfo[msg.sender].cumulative.add(reward);
//
//        emit ReceiveRewards(msg.sender, reward, userRewardInfo[msg.sender].cumulative);
//    }
//
//    function getUnlockRewards(address _account) public view returns (uint256) {
//        uint256 reward = 0;
//        if (userLockInfo[_account].lockVolume > 0) {
//            uint256 timeDifference = block.timestamp.sub(userLockInfo[_account].lastLockTime);
//            if (timeDifference > 0) {
//                if (timeDifference >= lockTime) {
//                    reward = userLockInfo[_account].lockVolume;
//                } else {
//                    uint256 currentRewards = timeDifference.mul(userLockInfo[_account].unlockingSpeed);
//                    if (currentRewards >= userLockInfo[_account].lockVolume) {
//                        reward = userLockInfo[_account].lockVolume;
//                    } else {
//                        reward = currentRewards;
//                    }
//                }
//            }
//        }
//        return reward;
//    }
//
//    function getUnclaimed(address _account) public view returns (uint256) {
//        uint256 unclaimed = getUnlockRewards(_account).add(userRewardInfo[_account].unclaimed);
//        return unclaimed;
//    }
//
//    function getUserLockInfo(address _account) public view returns (uint256, LockInfo memory, RewardInfo memory) {
//        return (totalLockVolume, userLockInfo[_account], userRewardInfo[_account]);
//    }
//
//    function setLockDays(uint256 _num) public onlyOperator {
//        lockTime = _num * 1 days;
//    }
//
//}
