from brownie import TheToken
from scripts.helpful_scripts import get_account
from web3 import Web3

initial_supply = Web3.toWei(1000, "ether")


def main():
    account = get_account(id='test-account')
    print(account)
    the_token = TheToken.deploy(initial_supply, {"from": account})
    # TheToken deployed at: 0xC4e15f3Bd9cf000087d40494d442f862c0958152
    print(the_token.name())
