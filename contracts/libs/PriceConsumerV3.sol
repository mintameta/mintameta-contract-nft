// SPDX-License-Identifier: MIT
pragma solidity ^0.6.7;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract PriceConsumerV3 {
    uint256 public randomNum;

    function getRandom(uint amount) external returns (uint256) {
        uint256 random = uint256(keccak256(abi.encodePacked(
                (block.timestamp) +
                (block.difficulty) +
                ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)) +
                (block.gaslimit) +
                // todo The official network needs to take a random number
                (block.number + 10086 + randomNum)
//                (block.number + 10086 + randomNum + uint(getLatestPrice()))
            ))) % amount;
        randomNum++;
        return random;
    }

    AggregatorV3Interface internal priceFeed;

    /**
     * Aggregator: ETH/USD
     */
    constructor(address addr) public {
        priceFeed = AggregatorV3Interface(addr);
    }

    /**
     * Returns the latest price
     */
    function getLatestPrice() private view returns (int) {
        (
        uint80 roundID,
        int price,
        uint startedAt,
        uint timeStamp,
        uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        return price;
    }
}
