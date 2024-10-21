// SPDX-License-Identifier: UNLICENSED 
pragma solidity 0.8.20; 
 
import {Script} from "forge-std/Script.sol"; 
import "../src/MyAdapter.sol"; 
 
contract MyAdapterScript is Script { 
    function run() public { 
        address SRC_TEST_TOKEN = vm.envAddress("SRC_TEST_TOKEN");
        address SRC_LAYERZERO_ENDPOINT = vm.envAddress("SRC_LAYERZERO_ENDPOINT");

        // Setup 
        uint256 privateKey = vm.envUint("PRIVATE_KEY"); 
        vm.startBroadcast(privateKey); 
 
        // Deploy 
        MyAdapter myAdapter = new MyAdapter(
            SRC_TEST_TOKEN,
            SRC_LAYERZERO_ENDPOINT,
            vm.addr(privateKey) // Address of private key 
        ); 
 
        vm.stopBroadcast(); 
    } 
}