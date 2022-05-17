from brownie import Lottery, accounts, network, config
from web3 import Web3

# 24547816664031531 (wei) => 0.0245478... (ether)
def test_get_entrance_fee():
    account = accounts[0]
    lottery = Lottery.deploy(
        config["networks"][network.show_active()]["eth_usd_price_feed"],
        {"from": account}
    )
    entrance_fee = lottery.getEntranceFee()
    assert  entrance_fee > Web3.toWei(0.023, "ether")
    assert  entrance_fee < Web3.toWei(0.025, "ether")


