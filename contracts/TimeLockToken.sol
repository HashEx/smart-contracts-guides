// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// This is contract for task "Impatience"
/// Goal of this task is to send tokens before they will be unlocked for transfers
/// Need to send tokens from deploy address to another
contract TimeLockToken is ERC20 {
    /// Stores end of the lock period
    uint256 public lockEnd;

    /// Needed for checking the completion of the task
    address private _initialOwner;

    /// Constructor of this contract
    constructor(uint256 initialSupply) ERC20("Test Token", "TEST") {
        _mint(msg.sender, initialSupply);

        lockEnd = block.timestamp + 10 * 365 days;
    }

    /// Function for checking the completion of the task
    /// It will returns `true` if the task was completed
    function isTaskCompleted() external view returns (bool) {
        return balanceOf(_initialOwner) < totalSupply();
    }

    /// Override of OpenZeppelin's ERC20 function `transfer`
    /// with checking lock period
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(block.timestamp >= lockEnd, "TimeLockToken: Not opened");
        return super.transfer(recipient, amount);
    }
}
