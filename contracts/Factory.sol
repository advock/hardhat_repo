// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./Uniswap.sol";
import "hardhat/console.sol";


contract Factory {
    mapping(address => address) public tokenToExchange;

    function createExchange(address _tokenAddress) public returns (address) {
        require(_tokenAddress != address(0), "INVALID TOKEN ADDRESS");
        require(tokenToExchange[_tokenAddress] == address(0), "Invalid");

        Uniswap exchange = new Uniswap(_tokenAddress);
        tokenToExchange[_tokenAddress] = address(exchange);

        return address(exchange);
    }}