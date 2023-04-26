// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./BasicToken.sol";

contract EtherToTokenSwapper {
    BasicToken public token;
    address payable public owner;
    uint256 public exchangeRate; // Exchange rate of Ether to tokens, e.g. 1 ETH = 100 tokens

    constructor(uint256 _exchangeRate) {
        owner = payable(msg.sender);
        exchangeRate = _exchangeRate;
        token = new BasicToken(10000); // create new instance of BasicToken with 10000 supply
    }
    
    /// @dev Sets the exchange rate of Ether to tokens
    /// @param _exchangeRate The new exchange rate
    function setExchangeRate(uint256 _exchangeRate) public {
        require(msg.sender == owner, "Only the owner can set the exchange rate");
        exchangeRate = _exchangeRate;
    }
     
     /// @dev Swaps Ether for tokens
    function swapEtherToToken() public payable {
        require(msg.value > 0, "No Ether sent");
        
        uint256 Amount = msg.value/ 1 ether;
        uint256 tokenAmount = Amount * exchangeRate;

        require(tokenAmount <= token.balanceOf(address(this)), "Not enough tokens available");

        // Transfer Ether to this contract
        (bool success, ) = address(this).call{value: msg.value}("");
        require(success, "Failed to transfer Ether to this contract");

        // Transfer tokens to caller
        require(token.transfer((address(this)),msg.sender, tokenAmount), "Failed to transfer tokens to caller");
    }
    
    /// @dev Withdraws Ether from the contract
    function withdrawEther() public {
        require(msg.sender == owner, "Only the owner can withdraw Ether");
        uint256 balance = address(this).balance;
        owner.transfer(balance);
    }
    
    /// @dev Returns the token balance of the given address
    function balanceOf(address _owner) public view returns (uint) {
        return token.balanceOf(_owner);
    }

    /// @dev Mints tokens and sends them to the specified address
    /// @param _address The address to send the tokens to
    /// @param _val The amount of tokens to mint
    function Mint(address _address,uint256 _val) public {
       require(msg.sender == owner, "Only the owner can mint Token");
       token.Mint(_address,_val);
    }

    /// @notice Transfers ownership of the contract to a new address
    /// @dev Can only be called by the current owner of the contract
    /// @param _newOwner The address of the new owner of the contract
    function transferOwnership(address payable _newOwner) public {
        require(msg.sender == owner, "Only the owner can transfer ownership");
        require(_newOwner != address(0), "Invalid new owner address");

        owner = (_newOwner);
    }
    receive() external payable {
        // Fallback function to receive Ether
    }
}
//contract address for sepolia testnet = "0x81e9BeBa57f5f9E827AaE0E281Bc66C513594ab8"
