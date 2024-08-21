// SPDX-License-Identifier: MIT

/* Fundraiser Contract
 * This contract facilitates a fundraiser where Ether donations are collected
 * until a specified goal is met. Once the goal is met, the contract ends
 * and transfers all funds to the recipient.
 */

pragma solidity 0.8.25;

contract Fundraiser {

    address payable public recipient;
    uint256 public goal;
    uint256 public totalRaised;
    bool public goalMet;

    // Logs when a transaction is completed using "event"
    event TransactionCompleted(address indexed sender, address indexed recipient, uint256 amount);
    
    // Logs when the fundraising is complete using "event"
    event FundraiserCompleted(uint256 totalAmountRaised);

    // Constructor that sets the recipient address and the fundraising goal
    constructor(address payable _recipient, uint256 _goal) {
        recipient = _recipient;
        totalRaised = 0;
        goalMet = false;
        goal = _goal;
    }

    // Function to facilitate a donation
    function facilitateDonation() public payable {
        require(msg.value > 0, "Transaction must have a value greater than 0");
        require(!goalMet, "Fundraising goal has already been met");

        // Transfer Ether to recipient (contract initiator)
        recipient.transfer(msg.value);

        // Update the total amount of Ether raised for the fundraiser
        totalRaised += msg.value;

        // Emit the transaction event
        emit TransactionCompleted(msg.sender, recipient, msg.value);

        // Check if the fundraising goal has been met
        if (totalRaised >= goal) {
            goalMet = true;
            emit FundraiserCompleted(totalRaised);
            endFundraiser();
        }
    }

    // Internal function to end the fundraiser and self-destruct the contract
    function endFundraiser() internal {
        // Transfer any remaining balance to the recipient
        recipient.transfer(address(this).balance);
    }
}