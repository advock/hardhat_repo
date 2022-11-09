// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "hardhat/console.sol";


contract Uniswap is ERC20 {
    address public tokenaddress;

    constructor(address _token) ERC20("AdvaiyaSwap", "AK") {
        require(_token != address(0), "invalid token address");
        tokenaddress = _token;
    }

    function addLiquidity(uint256 _tokenAmount)
        public
        payable
        returns (uint256)
    {
        if (getReserve() == 0) {
            IERC20 token = IERC20(tokenaddress);
            token.transferFrom(msg.sender, address(this), _tokenAmount);
            uint256 liquidity = address(this).balance;
            _mint(msg.sender, liquidity);

            return liquidity;
        } else {
            uint256 ethReserve = address(this).balance - msg.value;
            uint256 tokenReserve = getReserve();
            uint256 tokenAmount = (msg.value * tokenReserve) / ethReserve;
            require(_tokenAmount >= tokenAmount, "insufficient added");
            IERC20 token = IERC20(tokenaddress);
            token.transferFrom(msg.sender, address(this), tokenAmount);
            uint256 liquidity = (totalSupply() * msg.value) / ethReserve;
            _mint(msg.sender, liquidity);
            return liquidity;
        }
    }

    function getReserve() public view returns (uint256) {
        return IERC20(tokenaddress).balanceOf(address(this));
    }

    function getprice(uint256 inputReserve, uint256 outputReserve)
        public
        pure
        returns (uint256)
    {
        require(inputReserve > 0 && outputReserve > 0, "Invalid reserve");

        return (inputReserve * 1000) / outputReserve;
    }

    function getamount(
        uint256 inputAmount,
        uint256 inputReserve,
        uint256 outputReserve
    ) private pure returns (uint256) {
        require(inputReserve > 0 && outputReserve > 0, " Invalid Reserve");
        uint256 inputAmountWithFee = inputAmount * 99;
        uint256 numerator = inputAmountWithFee * outputReserve;
        uint256 denominator = (inputReserve * 100) + inputAmountWithFee;

        return numerator / denominator;
    }

    function getTokenAmount(uint256 _ethsol) public view returns (uint256) {
        require(_ethsol > 0, "ethsol is tooo small");

        uint256 tokenReserve = getReserve();

        return getamount(_ethsol, address(this).balance, tokenReserve);
    }

    function getEthAmount(uint256 _tokensold) public view returns (uint256) {
        require(_tokensold > 0, "_token too small");

        uint256 tokenReserve = getReserve();

        return getamount(_tokensold, tokenReserve, address(this).balance);
    }

    // swapping function

    function EthToToken(uint256 _mintToken) public payable {
        uint256 tokenReserve = getReserve();
        uint256 tokensBrought = getamount(
            msg.value,
            address(this).balance - msg.value,
            tokenReserve
        );

        require(tokenReserve >= _mintToken, "Insufficient output amount");
        IERC20(tokenaddress).transfer(msg.sender, tokensBrought);
    }

    function TokenToEth(uint256 _tokenSold, uint256 _minEth) public {
        uint256 tokenReserve = getReserve();
        uint256 ethBought = getamount(
            _tokenSold,
            tokenReserve,
            address(this).balance
        );

        require(ethBought > _minEth, "insufficienct output amount ");

        IERC20(tokenaddress).transfer(msg.sender, _tokenSold);
        payable(msg.sender).transfer(ethBought);
    }

    function removeLiquidity(uint256 _amount)
        public
        returns (uint256, uint256)
    {
        require(_amount > 0, "invalid");
        uint256 ethAmount = (address(this).balance * _amount) / totalSupply();
        uint256 tokenAmount = (getReserve() * _amount) / totalSupply();
        _burn(msg.sender, _amount);
        payable(msg.sender).transfer(ethAmount);
        IERC20(tokenaddress).transfer(msg.sender, tokenAmount);
        return(ethAmount,tokenAmount);
    }
}
