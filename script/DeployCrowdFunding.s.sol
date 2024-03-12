// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {CrowdFunding} from "../src/CrowdFunding.sol";

contract DeployCrowdFunding is Script {
    CrowdFunding public crowdFunding;
    address public constant TOKEN_ADDRESS =
        0x6d22DF74704E6d25a8b1611A6C541d2b9367e2e7;

    function run() external {
        vm.startBroadcast(vm.envUint("ENV_PRIVATE_KEY"));
        crowdFunding = new CrowdFunding(TOKEN_ADDRESS);
        vm.stopBroadcast();
    }
}
