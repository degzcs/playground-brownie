// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract Lottery {

	address payable[] public players;
	uint256 public usdEntryFee;
	AggregatorV3Interface internal ethUsdPriceFeed;

	constructor(address _priceFeedAddress) public {
		// NOTE: this is the minimum value for each user
		// to enter the lottery
		// NOTE: the values should be in Wei always (no decimals in Solidity)
		usdEntryFee = 50 * (10 ** 18);

		// Get the Price Feed from the XXX network
		ethUsdPriceFeed = AggregatorV3Interface(_priceFeedAddress);
	}

	function enter() public payable {
		players.push(msg.sender);

	}

	function getEntranceFee() public view returns (uint256) {
		// NOTE we are going to convert $ 50 dollars to Eth

	}

	function startLottery() public {

	}

	function endLottery() public {

	}
}
