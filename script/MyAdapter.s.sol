// SPDX-License-Identifier: UNLICENSED 
pragma solidity 0.8.20; 
 
import {Script} from "forge-std/Script.sol"; 
import "../src/MyAdapter.sol"; 
 
contract MyAdapterScript is Script { 
    address constant MY_TOKEN = 0x49Da2478f5a3eE8f82aE569fFFe3Ce21Aa16E3f0; 
    address constant LAYERZERO_ENDPOINT = 
        0x6EDCE65403992e310A62460808c4b910D972f10f; 
 
    function run() public { 
        // Setup 
        uint256 privateKey = vm.envUint("PRIVATE_KEY"); 
        vm.startBroadcast(privateKey); 
 
        // Deploy 
        MyAdapter myAdapter = new MyAdapter( 
            MY_TOKEN, 
            LAYERZERO_ENDPOINT, 
            vm.addr(privateKey) // Address of private key 
        ); 
 
        vm.stopBroadcast(); 
    } 
}