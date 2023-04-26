// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BasicToken {
    string public name = "Basic Token";
    string public symbol = "BT";
    mapping(address => uint) public balances;

    constructor(uint _supply) {
        balances[msg.sender] = _supply;
    }

    function transfer(address _from,address _to, uint _value) public returns (bool success) {
        require(balances[_from] >= _value, "Insufficient balance");
        balances[_from] -= _value;
        balances[_to] += _value;

        return true;
    }
    function balanceOf(address _owner) public view returns (uint) {
        return balances[_owner];
    }
    function Mint(address _address,uint256 _val) public {
       balances[_address]+=_val;
    }
}
