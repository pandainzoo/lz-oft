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

### add deps
```
pw forge install OpenZeppelin/openzeppelin-contracts@v5.0.2 --no-commit
pw forge install OpenZeppelin/openzeppelin-contracts-upgradeable@v5.0.2 --no-commit
pw forge install https://github.com/LayerZero-Labs/devtools --no-commit
pw forge install https://github.com/LayerZero-Labs/layerzero-v2 --no-commit
pw forge install https://github.com/GNSPS/solidity-bytes-utils --no-commit
```

## 用法
### L1部署ERC20
合约文件位于src/ERC20.sol
```
forge create src/ERC20.sol:ERC20 --constructor-args TestCOOK TCOOK $(bc<<<10^18*10^9*5) --rpc-url https://rpc.ankr.com/eth --private-key $KEY

Token合约地址填入.env文件SRC_TEST_TOKEN
```

### L1部署 token adapter
```
# deploy sepolia adapter
forge script script/MyAdapter.s.sol --rpc-url https://rpc.sepolia.org/ --broadcast

adapter合约地址填入.env文件SRC_ADAPTER_ADDRESS
```

### L2部署adapter对应的oft token & setPeer
```
// For Mantle
forge script script/MyOFT.s.sol --rpc-url https://rpc.sepolia.mantle.xyz --broadcast

oft合约地址填入.env文件DST_OFT_ADDRESS

// For OP
forge script script/MyOFT.s.sol --rpc-url https://sepolia.optimism.io --broadcast 
```

### L1 adapter合约 setPeer
```
# config adapter
forge script script/Bridge.s.sol -s "setPeer()" --rpc-url https://rpc.sepolia.org/ --broadcast
```

### layerzero setConfig
```
# ethereum set config for send lib
forge script script/Config.s.sol -s "setConfig(address,address,address,address[],uint32,uint64)" 0x6EDCE65403992e310A62460808c4b910D972f10f 0x2838479f0dbb534D315Ad24e0855a89230866044 0xcc1ae8Cf5D3904Cef3360A9532B477529b177cCE \[0x8eebf8b423b73bfca51a1db4b7354aa0bfca9193,0xa6bcc8c553ea756c8ad393d2cf379bfb59856499\] 40246 2 --rpc-url https://rpc.sepolia.org --broadcast

forge script script/Config.s.sol -s "setConfig(address,address,address,address[],uint32,uint64)" 0x6EDCE65403992e310A62460808c4b910D972f10f 0x2838479f0dbb534D315Ad24e0855a89230866044 0xcc1ae8Cf5D3904Cef3360A9532B477529b177cCE \[0xa6bcc8c553ea756c8ad393d2cf379bfb59856499\] 40246 2 --rpc-url https://rpc.sepolia.org --broadcast

# ethereum set config for receive lib
forge script script/Config.s.sol -s "setConfig(address,address,address,address[],uint32,uint64)" 0x6EDCE65403992e310A62460808c4b910D972f10f 0x2838479f0dbb534D315Ad24e0855a89230866044 0xdAf00F5eE2158dD58E0d3857851c432E34A3A851 \[0x8eebf8b423b73bfca51a1db4b7354aa0bfca9193,0xa6bcc8c553ea756c8ad393d2cf379bfb59856499\] 40246 2 --rpc-url https://rpc.sepolia.org --broadcast 

forge script script/Config.s.sol -s "setConfig(address,address,address,address[],uint32,uint64)" 0x6EDCE65403992e310A62460808c4b910D972f10f 0x2838479f0dbb534D315Ad24e0855a89230866044 0xdAf00F5eE2158dD58E0d3857851c432E34A3A851 \[0xa6bcc8c553ea756c8ad393d2cf379bfb59856499\] 40246 2 --rpc-url https://rpc.sepolia.org --broadcast 


# mantle set config for send lib
forge script script/Config.s.sol -s "setConfig(address,address,address,address[],uint32,uint64)" 0x6EDCE65403992e310A62460808c4b910D972f10f 0x7AE0a4846d6af3B82A5bd0F7a6a362784d9a2157 0x9A289B849b32FF69A95F8584a03343a33Ff6e5Fd \[0x9454f0EABc7C4Ea9ebF89190B8bF9051A0468E03,0xa8b188a6eb601d0cc82685d912718feca8d36e2f\] 40161 2 --rpc-url https://rpc.sepolia.mantle.xyz --broadcast

forge script script/Config.s.sol -s "setConfig(address,address,address,address[],uint32,uint64)" 0x6EDCE65403992e310A62460808c4b910D972f10f 0x7AE0a4846d6af3B82A5bd0F7a6a362784d9a2157 0x9A289B849b32FF69A95F8584a03343a33Ff6e5Fd \[0xa8b188a6eb601d0cc82685d912718feca8d36e2f\] 40161 2 --rpc-url https://rpc.sepolia.mantle.xyz --broadcast


# mantle set config for receive lib
forge script script/Config.s.sol -s "setConfig(address,address,address,address[],uint32,uint64)" 0x6EDCE65403992e310A62460808c4b910D972f10f 0x7AE0a4846d6af3B82A5bd0F7a6a362784d9a2157 0x8A3D588D9f6AC041476b094f97FF94ec30169d3D \[0x9454f0EABc7C4Ea9ebF89190B8bF9051A0468E03,0xa8b188a6eb601d0cc82685d912718feca8d36e2f\] 40161 2 --rpc-url https://rpc.sepolia.mantle.xyz --broadcast

forge script script/Config.s.sol -s "setConfig(address,address,address,address[],uint32,uint64)" 0x6EDCE65403992e310A62460808c4b910D972f10f 0x7AE0a4846d6af3B82A5bd0F7a6a362784d9a2157 0x8A3D588D9f6AC041476b094f97FF94ec30169d3D \[0xa8b188a6eb601d0cc82685d912718feca8d36e2f\] 40161 2 --rpc-url https://rpc.sepolia.mantle.xyz --broadcast
```

### 查询layerzero config配置
```
forge script script/Config.s.sol -s "getConfig(address,address,address,uint32)" 0x6EDCE65403992e310A62460808c4b910D972f10f 0x2838479f0dbb534D315Ad24e0855a89230866044 0xcc1ae8Cf5D3904Cef3360A9532B477529b177cCE 40246 --rpc-url https://rpc.sepolia.org
== Logs ==
  confirmations: 2
  requiredDVNCount: 1
  optionalDVNCount: 0
  optionalDVNThreshold: 0
  requiredDVNs
  0x8eebf8b423B73bFCa51a1Db4B7354AA0bFCA9193
  optionalDVNs

# get ethereum config receive lib
forge script script/Config.s.sol -s "getConfig(address,address,address,uint32)" 0x6EDCE65403992e310A62460808c4b910D972f10f 0x2838479f0dbb534D315Ad24e0855a89230866044 0xdAf00F5eE2158dD58E0d3857851c432E34A3A851 40246 --rpc-url https://rpc.sepolia.org
== Logs ==
  confirmations: 16
  requiredDVNCount: 1
  optionalDVNCount: 0
  optionalDVNThreshold: 0
  requiredDVNs:
  0x8eebf8b423B73bFCa51a1Db4B7354AA0bFCA9193
  optionalDVNs:

# get mantle config send lib
forge script script/Config.s.sol -s "getConfig(address,address,address,uint32)" 0x6EDCE65403992e310A62460808c4b910D972f10f 0x7AE0a4846d6af3B82A5bd0F7a6a362784d9a2157 0x9A289B849b32FF69A95F8584a03343a33Ff6e5Fd 40161 --rpc-url https://rpc.sepolia.mantle.xyz
== Logs ==
  confirmations: 2
  requiredDVNCount: 1
  optionalDVNCount: 0
  optionalDVNThreshold: 0
  requiredDVNs
  0x9454f0EABc7C4Ea9ebF89190B8bF9051A0468E03
  optionalDVNs

# get mantle config receive lib
forge script script/Config.s.sol -s "getConfig(address,address,address,uint32)" 0x6EDCE65403992e310A62460808c4b910D972f10f 0x7AE0a4846d6af3B82A5bd0F7a6a362784d9a2157 0x8A3D588D9f6AC041476b094f97FF94ec30169d3D 40161 --rpc-url https://rpc.sepolia.mantle.xyz
== Logs ==
  confirmations: 2
  requiredDVNCount: 1
  optionalDVNCount: 0
  optionalDVNThreshold: 0
  requiredDVNs
  0x9454f0EABc7C4Ea9ebF89190B8bF9051A0468E03
  optionalDVNs
```

### 资产跨链
```
# bridge L1 to L2
forge script script/Bridge.s.sol -s "bridge()" --rpc-url https://rpc.sepolia.org/ --broadcast

# 查询跨链result
cast call 0xA908254Fb22F0FCc29880f9A08F29eB48F013bad "balanceOf(address) (uint256)" 0x1220d2767171ea3a6F4a545efF23efaad4C80221  --rpc-url  https://rpc.sepolia.mantle.xyz

# bridge L2 to L1
forge script script/Bridge.s.sol -s "bridgeToL1()" --rpc-url https://rpc.sepolia.mantle.xyz --broadcast
```