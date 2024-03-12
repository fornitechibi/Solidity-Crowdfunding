// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {CrowdFunding} from "../src/CrowdFunding.sol";
import {DeployCrowdFunding} from "../script/DeployCrowdFunding.s.sol";
import {Vm} from "forge-std/Vm.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {MyToken} from "../src/MyToken.sol";

contract CrowdFundingTest is Test {
    CrowdFunding public crowdFunding;
    MyToken public myToken;

    address private owner;
    address private user1;
    address private user2;

    function setUp() public {
        owner = makeAddr("owner");
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");

        myToken = new MyToken("MyToken", "MTK", 18);
        myToken.mint(owner, 1_000_000 * 10 ** 18);
        myToken.mint(user1, 100_000 * 10 ** 18);
        myToken.mint(user2, 100_000 * 10 ** 18);

        vm.startPrank(owner);
        crowdFunding = new CrowdFunding(address(myToken));
        vm.stopPrank();
    }

    function testCreateCampaign() public {
        // Arrange
        vm.startPrank(owner);
        crowdFunding.createCampaign(100, 30 seconds);
        vm.stopPrank();
        // Act
        uint256 campaignId = crowdFunding.campaignCount();
        (
            uint256 id,
            address creator,
            uint256 goal,
            uint256 deadline,
            uint256 raisedAmount
        ) = crowdFunding.campaigns(campaignId);
        // Assert
        assertEq(id, campaignId);
        assertEq(creator, owner);
        assertEq(goal, 100);
        assertEq(deadline, block.timestamp + 30 seconds);
        assertEq(raisedAmount, 0);
    }
}
