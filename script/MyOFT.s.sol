// SPDX-License-Identifier: UNLICENSED 
pragma solidity 0.8.20; 
 
import {Script} from "forge-std/Script.sol"; 
import "../src/MyOFT.sol"; 
 
contract MyOFTScript is Script {
    function run() public { 
        // Setup 
        address SEPOLIA_ADAPTER_ADDRESS = vm.envAddress("SEPOLIA_ADAPTER_ADDRESS");
        uint256 SEPOLIA_ENDPOINT_ID = vm.envUint("SEPOLIA_ENDPOINT_ID");
        address SEPOLIA_LAYERZERO_ENDPOINT = vm.envAddress("SEPOLIA_LAYERZERO_ENDPOINT");

        uint256 privateKey = vm.envUint("PRIVATE_KEY"); 
        vm.startBroadcast(privateKey); 
 
        // Deploy 
        MyOFT myOFT = new MyOFT( 
            "Layer Zero TEST", 
            "lzTEST", 
            SEPOLIA_LAYERZERO_ENDPOINT, 
            vm.addr(privateKey) // Wallet address of signer 
        ); 
 
        // Hook up Mantle OFT to Sepolia's adapter 
        myOFT.setPeer( 
            uint32(SEPOLIA_ENDPOINT_ID), 
            bytes32(uint256(uint160(SEPOLIA_ADAPTER_ADDRESS))) 
        ); 
        vm.stopBroadcast(); 
    } 
}