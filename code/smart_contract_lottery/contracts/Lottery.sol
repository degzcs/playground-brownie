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

	function getVersion() public view returns (uint256){
		return ethUsdPriceFeed.version();
	}

	function getEntranceFee() public view returns (uint256) {
		// NOTE we are going to convert $ 50 dollars to Eth
		(,int price,,,) = ethUsdPriceFeed.latestRoundData();
		// NOTE Chainlink says that the price will contain 8 decimals
		// so we have to multiply this number by (10 ** 10) and we are
		// going to have 18 decimals at the end (this is a WEI)
		// ex. 202577000000 (this is the price of 1 Eth in dollars -> 8 decimals)
		// -> 2_025_77000000 -> 2_025_770000000000000000 (wei)
		uint256 adjustedPrice = uint256(price) * 10**10;
		// NOTE we are going to add 18 zeros to the entry dollars fee ($50)
		// the idea is that those new 18 zeros are going to cancel out 
		// with the zeros from price
		// ex. 50_000000000000000000 (this is already wei)
		// -> 50_000000000000000000_000000000000000000/2_025_770000000000000000 
		// 50_00000000000000000_00/2_025_77 -> 24547816664031531 (WEI)
		uint256 costToEnter = (usdEntryFee * 10**18)/adjustedPrice;
		return costToEnter;
	}

	function startLottery() public {

	}

	function endLottery() public {

	}
}
