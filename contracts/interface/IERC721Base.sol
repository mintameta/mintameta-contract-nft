// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface IERC721Base is IERC721 {
    function transferFrom1(
        address from,
        address to,
        uint256 tokenId,
        uint256 amount
    ) external;

}
