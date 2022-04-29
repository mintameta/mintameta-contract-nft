// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract ERC20Token is
ERC20('USDT', 'USDT')
{
    constructor()  {
        _mint(msg.sender, 100000000 *10e17);
    }

    function decimals() public pure override returns (uint8) {
        return 18;
    }
}
