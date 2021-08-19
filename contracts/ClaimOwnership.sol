// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

/// This is contract for task "Claim ownership"
/// Goal of this task is to take ownership of a contract
contract ClaimOwnership {
    /// Stores the address of the owner of the contract
    address public owner;

    /// Indicates whether the contract has been initialized
    bool private _isInitialized;
    /// Needed for checking the completion of the task
    address private _previousOwner;

    /// Event that emitted on initializing
    event Initialized(address owner);
    /// Event that emitted on changing the address of the owner of the contract
    event OwnershipChanged(address oldOwner, address newOwner);

    /// Constructor of this contract
    constructor() {
        init();
        _previousOwner = msg.sender;
    }

    /// Function that performs initialization
    function init() public {
        require(!_isInitialized, "ClaimOwnership: Initialized");

        owner = msg.sender;

        emit Initialized(msg.sender);
    }

    // Funciton for the owner of a change of ownership contract
    function changeOwnership(address newOwner) external {
        /// Gas optimization:
        /// The state variable `owner` is read 3 times inside this function
        /// This variable could be stored in the stack
        /// Reading from stack is cheaper than from storage
        /// Reads from storage can be reduced to 1 instead of 3
        address _ownerOld = owner;

        require(msg.sender == _ownerOld, "ClaimOwnership: Not allowed");
        require(newOwner != _ownerOld, "ClaimOwnership: Diff");

        owner = newOwner;

        emit OwnershipChanged(_ownerOld, newOwner);
    }

    /// Function for checking the completion of the task
    /// It will returns `true` if the task was completed
    function isTaskCompleted() external view returns (bool) {
        return owner != _previousOwner;
    }
}
