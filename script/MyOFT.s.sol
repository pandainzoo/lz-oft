// SPDX-License-Identifier: UNLICENSED 
pragma solidity 0.8.20; 
 
import {Script} from "forge-std/Script.sol"; 
import "../src/MyOFT.sol"; 
 
contract MyOFTScript is Script {
    function run() public { 
        // Setup 
        address SRC_ADAPTER_ADDRESS = vm.envAddress("SRC_ADAPTER_ADDRESS");
        uint256 SRC_ENDPOINT_ID = vm.envUint("SRC_ENDPOINT_ID");
        address DST_LAYERZERO_ENDPOINT = vm.envAddress("DST_LAYERZERO_ENDPOINT");

        uint256 privateKey = vm.envUint("PRIVATE_KEY"); 
        vm.startBroadcast(privateKey); 
 
        // Deploy 
        MyOFT myOFT = new MyOFT( 
            "Layer Zero TEST", 
            "lzTEST", 
            DST_LAYERZERO_ENDPOINT, 
            vm.addr(privateKey) // Wallet address of signer 
        ); 
 
        // Hook up Mantle OFT to source chain adapter
        myOFT.setPeer( 
            uint32(SRC_ENDPOINT_ID),
            bytes32(uint256(uint160(SRC_ADAPTER_ADDRESS)))
        ); 
        vm.stopBroadcast(); 
    } 
}