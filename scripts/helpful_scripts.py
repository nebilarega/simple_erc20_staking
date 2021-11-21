from brownie import accounts, config, network

FORKED_LOCAL_ENVIROMENTS = ["mainnet-fork-dev", "mainnet-fork"]
LOCAL_ACCOUNT_ARRAY = ["development", "ganache-local"]


def get_accounts(index=None, ID=None):
    if index:
        return accounts[index]
    if ID:
        return accounts.load(ID)
    if network.show_active() in LOCAL_ACCOUNT_ARRAY or network.show_active() in FORKED_LOCAL_ENVIROMENTS:
        return accounts[0]
    return accounts.add(config["wallets"]["from_key"])
