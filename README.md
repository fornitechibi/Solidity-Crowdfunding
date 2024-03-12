# Crowd Funding

The use of blockchains really stands out when it comes to clear-cut crowdfunding. People can easily gather funds for their causes, and donors have the freedom to contribute using ERC-20 token.

Specifications:

- Anyone can create a new campaign by specifying the goal amount (in USD), and the duration.
- Any user, except for the creator of the campaign, can donate to any campaign using the token.
- Users can cancel their donations anytime for a particular campaign before the deadline has passed.
- If after the deadline has passed, the goal has not been reached, the campaign is said to be unsuccessful and donors can get their contributions back.

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
