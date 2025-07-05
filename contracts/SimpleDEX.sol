// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.3/contracts/token/ERC20/IERC20.sol";

contract SimpleDEX {
    address public owner;
    IERC20 public tokenA;
    IERC20 public tokenB;

    uint256 public reserveA;
    uint256 public reserveB;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    event LiquidityAdded(uint256 amountA, uint256 amountB);
    event LiquidityRemoved(uint256 amountA, uint256 amountB);
    event SwappedAforB(uint256 amountAIn, uint256 amountBOut);
    event SwappedBforA(uint256 amountBIn, uint256 amountAOut);

    constructor(address _tokenA, address _tokenB) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
        owner = msg.sender;
    }

    function addLiquidity(uint256 amountA, uint256 amountB) external onlyOwner {
        require(
            tokenA.transferFrom(msg.sender, address(this), amountA),
            "Transfer A failed"
        );
        require(
            tokenB.transferFrom(msg.sender, address(this), amountB),
            "Transfer B failed"
        );

        reserveA += amountA;
        reserveB += amountB;

        emit LiquidityAdded(amountA, amountB);
    }

    function swapAforB(uint256 amountAIn) external {
        require(
            tokenA.transferFrom(msg.sender, address(this), amountAIn),
            "Transfer A failed"
        );

        uint256 amountBOut = getAmountOut(amountAIn, reserveA, reserveB);
        require(tokenB.transfer(msg.sender, amountBOut), "Transfer B failed");

        reserveA += amountAIn;
        reserveB -= amountBOut;

        emit SwappedAforB(amountAIn, amountBOut);
    }

    function swapBforA(uint256 amountBIn) external {
        require(
            tokenB.transferFrom(msg.sender, address(this), amountBIn),
            "Transfer B failed"
        );

        uint256 amountAOut = getAmountOut(amountBIn, reserveB, reserveA);
        require(tokenA.transfer(msg.sender, amountAOut), "Transfer A failed");

        reserveB += amountBIn;
        reserveA -= amountAOut;

        emit SwappedBforA(amountBIn, amountAOut);
    }

    function removeLiquidity(
        uint256 amountA,
        uint256 amountB
    ) external onlyOwner {
        require(
            amountA <= reserveA && amountB <= reserveB,
            "Not enough liquidity"
        );

        reserveA -= amountA;
        reserveB -= amountB;

        require(tokenA.transfer(msg.sender, amountA), "Transfer A failed");
        require(tokenB.transfer(msg.sender, amountB), "Transfer B failed");

        emit LiquidityRemoved(amountA, amountB);
    }

    function getPrice(address _token) external view returns (uint256 price) {
        require(
            _token == address(tokenA) || _token == address(tokenB),
            "Invalid token"
        );
        require(reserveA > 0 && reserveB > 0, "Empty pool");

        if (_token == address(tokenA)) {
            return (reserveB * 1e18) / reserveA;
        }
        return (reserveA * 1e18) / reserveB;
    }

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) internal pure returns (uint256) {
        require(amountIn > 0, "Invalid input");
        require(reserveIn > 0 && reserveOut > 0, "Invalid reserves");

        // Constant product formula (no fees): (x + dx)(y - dy) = xy
        // Solve for dy: dy = (dx * y) / (x + dx)
        return (amountIn * reserveOut) / (reserveIn + amountIn);
    }
}
