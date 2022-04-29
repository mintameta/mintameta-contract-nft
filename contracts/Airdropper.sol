// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Ownable {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}

interface Token {
    function balanceOf(address _owner) external returns (uint256 );
    function transfer(address _to, uint256 _value) external ;
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
}

contract Airdrop is Ownable {
    event eDrop(address[] _recipients, uint[] _values, address _tokenAddress);
    event aWithdrawalToken(address _tokenAddress, uint value, address owner);

    function drop(address[] memory _recipients, uint[] calldata _values, address _tokenAddress) onlyOwner public returns (bool) {
        require(_recipients.length > 0);

        Token token = Token(_tokenAddress);

        for(uint j = 0; j < _recipients.length; j++){
            token.transfer(_recipients[j], _values[j]);
        }

        emit eDrop(_recipients, _values, _tokenAddress);
        return true;
    }

    function withdrawalToken(address _tokenAddress) onlyOwner public {
        Token token = Token(_tokenAddress);
        emit aWithdrawalToken(_tokenAddress, token.balanceOf(address(this)), owner);
        token.transfer(owner, token.balanceOf(address(this)));
    }

}

