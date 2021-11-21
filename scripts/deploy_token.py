from brownie import accounts, config, StakingToken
from web3 import Web3
from scripts.helpful_scripts import get_accounts

initial_supply = 1000000000
def deploy_token():
    account = get_accounts()
    if (len(StakingToken) <= 0):
        token = StakingToken.deploy(account, initial_supply, {'from': account})
    else:
        token = StakingToken[-1]

    print(f"Token Name: {token.name()}")
    print(f"Token Symbol: {token.symbol()}")

    print("-------------------- Function Calls ---------------------")



def main():
    deploy_token()
