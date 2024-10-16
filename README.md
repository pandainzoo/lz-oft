## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

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

```
# add deps
pw forge install OpenZeppelin/openzeppelin-contracts@v5.0.2 --no-commit
pw forge install OpenZeppelin/openzeppelin-contracts-upgradeable@v5.0.2 --no-commit
pw forge install https://github.com/LayerZero-Labs/devtools --no-commit
pw forge install https://github.com/LayerZero-Labs/layerzero-v2 --no-commit
pw forge install https://github.com/GNSPS/solidity-bytes-utils --no-commit

# deploy sepolia adapter
forge script script/MyAdapter.s.sol --rpc-url https://rpc.sepolia.org/ --broadcast

# deploy oft in dst chain
// For Mantle
forge script script/MyOFT.s.sol --rpc-url https://rpc.sepolia.mantle.xyz --broadcast 
// For OP
forge script script/MyOFT.s.sol --rpc-url https://sepolia.optimism.io --broadcast 

# config adapter
forge script script/Bridge.s.sol -s "setPeer()" --rpc-url https://rpc.sepolia.org/ --broadcast
# token cross chain
forge script script/Bridge.s.sol -s "bridge()" --rpc-url https://rpc.sepolia.org/ --broadcast

# query result
cast call 0xA908254Fb22F0FCc29880f9A08F29eB48F013bad "balanceOf(address) (uint256)" 0x1220d2767171ea3a6F4a545efF23efaad4C80221  --rpc-url  https://sepolia.optimism.io
```