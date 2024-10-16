// SPDX-License-Identifier: UNLICENSED 
pragma solidity 0.8.20; 
 
import {Script} from "forge-std/Script.sol"; 
import "../src/MyAdapter.sol"; 
 
contract MyAdapterScript is Script { 
    function run() public { 
        address SEPOLIA_TEST_TOKEN = vm.envAddress("SEPOLIA_TEST_TOKEN");
        address SEPOLIA_LAYERZERO_ENDPOINT = vm.envAddress("SEPOLIA_LAYERZERO_ENDPOINT");

        // Setup 
        uint256 privateKey = vm.envUint("PRIVATE_KEY"); 
        vm.startBroadcast(privateKey); 
 
        // Deploy 
        MyAdapter myAdapter = new MyAdapter( 
            SEPOLIA_TEST_TOKEN, 
            SEPOLIA_LAYERZERO_ENDPOINT, 
            vm.addr(privateKey) // Address of private key 
        ); 
 
        vm.stopBroadcast(); 
    } 
}