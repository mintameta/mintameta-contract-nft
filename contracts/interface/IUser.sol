// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IUser {
    struct UserInfo {
        // allow mortgage
        string name;
        address userAddress;
        string email;
        string website;
        string introduce;
        string haedImg;
        string bgImg;
        // 0default 1Unhandled 2pass 3reject
        uint status;
    }
    function getUserInfo(address addr_) external returns(UserInfo memory iUserInfo);
}

