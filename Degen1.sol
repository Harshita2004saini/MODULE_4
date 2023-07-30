// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {
    constructor() ERC20("Degen Token", "DEGEN") {}

    // Mint new tokens. Only the owner can call this function.
    function mint(address account, uint256 amount) public onlyOwner {
        _mint(account, amount);
    }

    // Transfer tokens from sender's account to another account.
    function transferTokens(address recipient, uint256 amount) public {
        _transfer(_msgSender(), recipient, amount);
    }

    // Redeem tokens for items in the in-game store.
    function redeem(uint256 itemCost) public {
        require(balanceOf(msg.sender) >= itemCost, "Not enough tokens to redeem");
        _burn(msg.sender, itemCost); // Burn the tokens from the sender's account
        // Additional logic for item redemption goes here
        emit Redeemed(msg.sender, itemCost);
    }

    // Event emitted when a user successfully redeems tokens for an item.
    event Redeemed(address indexed user, uint256 itemCost);
}
