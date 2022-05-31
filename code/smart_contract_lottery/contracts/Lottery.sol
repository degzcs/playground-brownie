// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";

contract Lottery is VRFConsumerBase, Ownable {
	address payable[] public players;
	address payable public recentWinner;
	uint256 public usdEntryFee;
	AggregatorV3Interface internal ethUsdPriceFeed;
	enum LOTTERY_STATE {
		OPEN,
		CLOSED,
		CALCULATING_WINNER
	}
	LOTTERY_STATE public lottery_state;
	uint256 public fee;
	bytes32 public keyHash;
	uint256 public randomness;
	event RequestedRandomness(bytes32 requestId);

	constructor(
		address _priceFeedAddress,
		address _vrfCoordinator,
		address _link,
		uint256 _fee,
		bytes32 _keyHash
	)
	public
	VRFConsumerBase(_vrfCoordinator, _link){
		// NOTE: this is the minimum value for each user
		// to enter the lottery
		// NOTE: the values should be in Wei always (no decimals in Solidity)
		usdEntryFee = 50 * (10 ** 18);

		// Get the Price Feed from the XXX network
		ethUsdPriceFeed = AggregatorV3Interface(_priceFeedAddress);
		lottery_state = LOTTERY_STATE.CLOSED;

		// This fee is the price that we have to pay for using
		// the randomness oracle service
		fee = _fee;

		// This is the way to identify the uniqueness of the chainlink node
		keyHash = _keyHash;
	}

	function enter() public payable {
		require(lottery_state == LOTTERY_STATE.OPEN);
		require(msg.value >= getEntranceFee(), "Not enough ETH!");
		players.push(msg.sender);
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

	function startLottery() public onlyOwner {
		require(lottery_state == LOTTERY_STATE.CLOSED,
						"Can't start a new lottery yet!");
		lottery_state = LOTTERY_STATE.OPEN;
	}

	function endLottery() public onlyOwner {
		lottery_state = LOTTERY_STATE.CALCULATING_WINNER;
		// NOTE this function will start the request-response process
		bytes32 requestId = requestRandomness(keyHash, fee);
		// node is going to return the response to a fulfillRandomness function
		// For testing we are going to emit an event here
		emit RequestedRandomness(requestId);
	}

	function fulfillRandomness(bytes32 _requestId, uint256 _randomness) internal override {
		require(lottery_state == LOTTERY_STATE.CALCULATING_WINNER, "You aren't there yet!");
		require(_randomness > 0, "randm-not-found");
		uint256 indexOfWinner = _randomness % players.length;
		recentWinner = players[indexOfWinner];
		recentWinner.transfer(address(this).balance);
		// Reset
		players = new address payable[](0);
		lottery_state = LOTTERY_STATE.CLOSED;
		randomness = _randomness;
	}
}
