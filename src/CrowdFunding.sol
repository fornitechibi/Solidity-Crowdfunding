// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MyToken.sol";

contract CrowdFunding {
    MyToken public immutable token;
    uint256 public campaignCount;
    address owner;

    struct Campaign {
        uint256 id;
        address payable creator;
        uint256 goal;
        uint256 deadline;
        uint256 raisedAmount;
    }

    struct Contribution {
        uint256 amount;
        bool exists;
    }

    mapping(uint256 => Campaign) public campaigns;
    mapping(uint256 => mapping(address => Contribution)) public contributions;

    event CampaignCreated(
        uint256 id,
        address creator,
        uint256 goal,
        uint256 deadline
    );
    event ContributionMade(uint256 id, address contributor, uint256 amount);
    event ContributionCanceled(uint256 id, address contributor, uint256 amount);
    event FundsWithdrawn(uint256 id, uint256 amount);
    event RefundClaimed(uint256 id, address contributor, uint256 amount);

    constructor(address _token) {
        token = MyToken(_token);
        campaignCount = 0;
    }

    function createCampaign(uint256 goal, uint256 duration) external {
        require(goal > 0, "Goal must be greater than zero");
        require(duration > 0, "Duration must be greater than zero");

        campaignCount++;
        uint256 id = campaignCount;
        uint256 deadline = block.timestamp + duration;

        campaigns[id] = Campaign(id, payable(msg.sender), goal, deadline, 0);

        emit CampaignCreated(id, msg.sender, goal, deadline);
    }

    function contribute(uint256 id, uint256 amount) external {
        Campaign storage campaign = campaigns[id];
        require(campaign.id != 0, "Campaign does not exist");
        require(
            block.timestamp < campaign.deadline,
            "Campaign deadline has passed"
        );

        Contribution storage contribution = contributions[id][msg.sender];
        require(!contribution.exists, "Contribution already exists");

        contribution.amount += amount;
        contribution.exists = true;
        campaign.raisedAmount += amount;
        require(
            token.transferFrom(msg.sender, address(this), amount),
            "Token transfer failed"
        );

        emit ContributionMade(id, msg.sender, amount);
    }

    function cancelContribution(uint256 id) external {
        Campaign storage campaign = campaigns[id];
        require(campaign.id != 0, "Campaign does not exist");
        require(
            block.timestamp < campaign.deadline,
            "Campaign deadline has passed"
        );

        Contribution storage contribution = contributions[id][msg.sender];
        require(contribution.exists, "No contribution to cancel");

        campaign.raisedAmount -= contribution.amount;
        contribution.exists = false;
        require(
            token.transfer(msg.sender, contribution.amount),
            "Token transfer failed"
        );

        emit ContributionCanceled(id, msg.sender, contribution.amount);
    }

    function withdrawFunds(uint256 id) external {
        Campaign storage campaign = campaigns[id];
        require(
            campaign.creator == msg.sender,
            "Only Owner of Campaign can withdraw"
        );
        require(campaign.id != 0, "Campaign does not exist");
        require(
            block.timestamp >= campaign.deadline,
            "Campaign deadline has not passed"
        );
        require(campaign.raisedAmount >= campaign.goal, "Goal not reached");
        require(
            msg.sender == campaign.creator,
            "Only creator can withdraw funds"
        );

        uint256 raisedAmount = campaign.raisedAmount;
        campaign.raisedAmount = 0;

        require(
            token.transfer(campaign.creator, raisedAmount),
            "Token transfer failed"
        );

        emit FundsWithdrawn(id, raisedAmount);
    }

    function refund(uint256 id) external {
        Campaign storage campaign = campaigns[id];
        require(campaign.id != 0, "Campaign does not exist");
        require(
            block.timestamp >= campaign.deadline,
            "Campaign deadline has not passed"
        );
        require(
            campaign.raisedAmount < campaign.goal,
            "Campaign was successful"
        );

        Contribution storage contribution = contributions[id][msg.sender];
        require(contribution.exists, "No contribution to refund");

        campaign.raisedAmount -= contribution.amount;
        uint256 refundAmount = contribution.amount;
        contribution.exists = false;

        require(
            token.transfer(msg.sender, refundAmount),
            "Token transfer failed"
        );

        emit RefundClaimed(id, msg.sender, refundAmount);
    }
}
