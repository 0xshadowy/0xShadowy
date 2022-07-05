// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "solmate/tokens/ERC721.sol";

abstract contract SoulBoundToken is ERC721 {
	constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

	function approve(address spender, uint256 id) public virtual override {
		revert("Approval not supported");
	}

    function setApprovalForAll(address operator, bool approved) public virtual override {
		revert("Approval not supported");
    }

    function transferFrom(address from, address to, uint256 id) public virtual override {
		revert("Transfer not supported");
	}

    function safeTransferFrom(address from, address to, uint256 id) public virtual override {
		revert("Transfer not supported");
	}

    function safeTransferFrom( address from, address to, uint256 id, bytes calldata data) public virtual override {
		revert("Transfer not supported");
	}
}
