// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IRandom {

    function getRandom(uint amount) external returns (uint256);

}
