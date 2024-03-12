// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {MyToken} from "../src/MyToken.sol";

contract DeployMyToken is Script {
    MyToken public myToken;

    function run() external {
        vm.startBroadcast(vm.envUint("ENV_PRIVATE_KEY"));
        myToken = new MyToken("BlockChainClub", "BCC", 1);
        vm.stopBroadcast();
    }
}
