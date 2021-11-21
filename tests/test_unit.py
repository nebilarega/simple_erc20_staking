from brownie import StakingToken
from scripts.helpful_scripts import get_accounts

initial_supply = 1000000000
def test_create_stake():
    account = get_accounts()
    if (len(StakingToken) <= 0):
        token = StakingToken.deploy(account, initial_supply, {'from': account})
    else:
        token = StakingToken[-1]
    stake = 100
    token.createStake(stake, {'from': account})
    assert token.totalSupply() == (initial_supply - stake)
    assert token.stakeOf(account) == stake


def test_delete_stake():
    account = get_accounts()
    if (len(StakingToken) <= 0):
        token = StakingToken.deploy(account, initial_supply, {'from': account})
    else:
        token = StakingToken[-1]
    stake = 100
    token.deleteStake(stake, {'from': account})
    assert token.totalSupply() == initial_supply
    assert len(token.returnStakeHolders()) == 0


def test_stake_balance():
    pass


