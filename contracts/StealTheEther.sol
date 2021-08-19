// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

/// This is contract for task "Steal the ether"
/// Goal of this task is to steal ether from this contract
contract StealTheEther {
    /// Used for calculating of hash
    /// It stores unique data for each hash guess
    uint256 public nonce;
    /// Stores the amount of the bet
    /// that the user submits to participate in this contract
    uint256 public betAmount = 1 ether;

    /// Event that emmited on correct guesses
    event CorrectGuess(address indexed sender, uint256 winAmount);
    /// Event that emmited on wrong guesses
    event WrongGuess(address indexed sender);

    /// Constructor of this contract
    constructor() payable {
        require(msg.value == 2 * betAmount, "StealTheEther: Wrong bet");
    }

    /// Function for hash guessing
    /// If the user makes a correct guess, he takes all previous bets
    function guess(bytes32 hashGuess) external payable {
        /// Gas optimization:
        /// The state variable `owner` is read 2 times inside this function
        /// This variable could be stored in the stack
        /// Reading from stack is cheaper than from storage
        /// Reads from storage can be reduced to 1 instead of 2
        uint256 _betAmount = betAmount;
        require(msg.value == _betAmount, "StealTheEther: Wrong bet");

        /// Gas optimization:
        /// `nonce` could be read twice
        /// then it must be written in the stack
        uint256 _nounce = nonce;
        bytes32 computedHash = keccak256(
            abi.encodePacked(blockhash(block.number), msg.sender, _nounce + 1)
        );

        if (hashGuess == computedHash) {
            /// Gas optimization:
            /// `address(this).balance` is read 3 times inside this function
            /// then it must be written in the stack
            uint256 winAmount = address(this).balance - _betAmount;

            (bool success, ) = msg.sender.call{value: winAmount}("");
            require(success, "StealTheEther: Transfer failed");

            emit CorrectGuess(msg.sender, winAmount);
        } else {
            nonce = _nounce + 1;

            emit WrongGuess(msg.sender);
        }
    }

    /// Function for checking the completion of the task
    /// It will returns `true` if the task was completed
    function isTaskCompleted() external view returns (bool) {
        return address(this).balance < 2 * betAmount;
    }
}
