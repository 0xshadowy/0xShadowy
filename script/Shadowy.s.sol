// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Shadower.sol";
import "../src/Repository.sol";

contract Shadowy is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();

		Repository repository = new Repository();
		Shadower shadower = new Shadower(address(repository));

		vm.stopBroadcast();
    }
}
