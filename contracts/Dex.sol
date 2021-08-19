// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// This is contract for task "Hack the swap"
/// Goal of this task is to steal tokens from this swap contract
///
/// For initializing this contract you need:
/// 1) Have 2 ERC20 tokens (token0 and token1)
/// 2) Have some token balances
/// 3) Deploy dex contract initializing it with this 2 ERC20 tokens
/// 4) Transfer some amount of both tokens on this dex contract

contract Dex {
    /// Stores the addresses of the first and the second tokens
    /// that is swaped on this contract
    address public token0;
    address public token1;

    /// Event that is emmited on swap
    event Swap(
        address indexed sender,
        address indexed fromToken,
        address indexed toToken,
        uint256 inputAmount,
        uint256 outputAmount
    );

    /// Constructor of this contract
    constructor(address _token0, uint256 token0Amount, address _token1, uint256 token1Amount) {
        require(
            _token0 != _token1,
            "Dex: Not unique tokens"
        );
        token0 = _token0;
        token1 = _token1;

        require(
            token0Amount > 0 &&
            IERC20(_token0).transferFrom(msg.sender, address(this), token0Amount),
            "Dex: TransferFrom token0 failed"
        );
        require(
            token1Amount > 0 &&
            IERC20(_token1).transferFrom(msg.sender, address(this), token1Amount),
            "Dex: TransferFrom token1 failed"
        );
    }

    /// Function to swap from one token to another
    /// `from` is token that user wants to sell
    /// `to` is token that user wants to buy
    /// `amount` is the number of `from` token to sell
    function swap(
        address from,
        address to,
        uint256 amount
    ) external {
        require(amount > 0, "Dex: Insufficient input");

        uint256 dexBalanceTokenFromBefore = IERC20(from).balanceOf(address(this));
        uint256 dexBalanceTokenToBefore = IERC20(to).balanceOf(address(this));
        require(
            dexBalanceTokenFromBefore > 0 && dexBalanceTokenToBefore > 0,
            "Dex: Reserves error"
        );

        require(
            IERC20(from).transferFrom(msg.sender, address(this), amount),
            "Dex: TransferFrom failed"
        );

        uint256 dexBalanceTokenFromAfter = IERC20(from).balanceOf(address(this));
        uint256 inputAmount = dexBalanceTokenFromAfter - dexBalanceTokenFromBefore;

        uint256 outputAmount = _getSwapPrice(
            dexBalanceTokenFromBefore,
            dexBalanceTokenToBefore,
            inputAmount
        );
        require(outputAmount > 0, "Dex: Insufficient output");
        require(IERC20(to).transfer(msg.sender, outputAmount), "Dex: Transfer failed");

        emit Swap(msg.sender, from, to, inputAmount, outputAmount);
    }

    /// Function for checking the completion of the task
    /// It will returns `true` if the task was completed
    function isTaskCompleted() external view returns (bool) {
        uint256 balanceToken0 = IERC20(token0).balanceOf(address(this));
        uint256 balanceToken1 = IERC20(token1).balanceOf(address(this));
        return balanceToken0 == 0 && balanceToken1 == 0;
    }

    /// Function for calculating the number of tokens that users buy
    /// `amount0` is the number of tokens on swap contract the user wants to sell
    /// `amount1` is the number of tokens on swap contract the user wants to buy
    /// `swapAmount` is the number of tokens that the user wants to sell
    function _getSwapPrice(
        uint256 amount0,
        uint256 amount1,
        uint256 swapAmount
    ) private pure returns (uint256) {
        return (swapAmount * amount1) / (amount0 + swapAmount);
    }
}
