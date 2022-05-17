from brownie import Lottery, accounts, network, config
from web3 import Web3

# 0.025 ether or 190000000000000000 wei (16 zeros)
def test_get_entrance_fee():
    account = accounts[0]
    lottery = Lottery.deploy(
        config["networks"][network.show_active()]["eth_usd_price_feed"],
        {"from": account}
    )
    value = lottery.getEntranceFee()
    assert value == 


