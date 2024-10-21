pragma solidity 0.8.20; 
 
import "forge-std/Script.sol"; 
import {IOFT, SendParam} from "@layerzerolabs/lz-evm-oapp-v2/contracts/oft/interfaces/IOFT.sol"; 
import {IOAppCore} from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/interfaces/IOAppCore.sol"; 
import {MessagingFee} from "@layerzerolabs/lz-evm-oapp-v2/contracts/oft/OFTCore.sol"; 
import {OptionsBuilder} from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/libs/OptionsBuilder.sol"; 
import "@openzeppelin/contracts/token/ERC20/IERC20.sol"; 
 
interface IAdapter is IOAppCore, IOFT {} 
 
contract SendOFTScript is Script { 
    using OptionsBuilder for bytes; 
 
    uint256 SRC_ENDPOINT_ID = vm.envUint("SRC_ENDPOINT_ID");
    uint256 DST_ENDPOINT_ID = vm.envUint("DST_ENDPOINT_ID");
    address SRC_TEST_TOKEN = vm.envAddress( "SRC_TEST_TOKEN" );
    address SRC_ADAPTER_ADDRESS = vm.envAddress( "SRC_ADAPTER_ADDRESS" );
    address DST_OFT_ADDRESS = vm.envAddress("DST_OFT_ADDRESS"); 

    function setPeer() external { 
        uint256 privateKey = vm.envUint("PRIVATE_KEY"); 
        vm.startBroadcast(privateKey); 
 
        // Get the Adapter contract instance 
        IAdapter srcAdapter = IAdapter(SRC_ADAPTER_ADDRESS);
 
        // Hook up source chain Adapter to Mantle's OFT
        srcAdapter.setPeer(
            uint32(DST_ENDPOINT_ID), 
            bytes32(uint256(uint160(DST_OFT_ADDRESS))) 
        ); 
    } 


    function bridge() external { 
        uint256 privateKey = vm.envUint("PRIVATE_KEY"); 
        vm.startBroadcast(privateKey); 
        address signer = vm.addr(privateKey); 
 
        // Get the Adapter contract instance 
        IAdapter srcAdapter = IAdapter(SRC_ADAPTER_ADDRESS);
 
        // Define the send parameters 
        uint256 tokensToSend = 1 ether; 
 
        bytes memory options = OptionsBuilder 
            .newOptions() 
            .addExecutorLzReceiveOption(200000, 0); 
 
        SendParam memory sendParam = SendParam( 
            uint32(DST_ENDPOINT_ID), 
            bytes32(uint256(uint160(signer))), 
            tokensToSend, 
            tokensToSend, 
            options, 
            "", 
            "" 
        ); 
 
        // Quote the send fee 
        MessagingFee memory fee = srcAdapter.quoteSend(sendParam, false);
        console.log("Native fee: %d", fee.nativeFee); 
 
        // Approve the OFT contract to spend UNI tokens 
        IERC20(SRC_TEST_TOKEN).approve(
            SRC_ADAPTER_ADDRESS,
            tokensToSend 
        ); 
 
        // Send the tokens 
        srcAdapter.send{value: fee.nativeFee}(sendParam, fee, signer);
 
        console.log("Tokens bridged successfully!"); 
    } 

    function bridgeToL1() external { 
        uint256 privateKey = vm.envUint("PRIVATE_KEY"); 
        vm.startBroadcast(privateKey); 
        address signer = vm.addr(privateKey); 
 
        // Get the Adapter contract instance 
        IAdapter iAdapter = IAdapter(DST_OFT_ADDRESS); 
 
        // Define the send parameters 
        uint256 tokensToSend = 0.1 ether; 
 
        bytes memory options = OptionsBuilder 
            .newOptions() 
            .addExecutorLzReceiveOption(200000, 0); 
 
        SendParam memory sendParam = SendParam( 
            uint32(SRC_ENDPOINT_ID),
            bytes32(uint256(uint160(signer))), 
            tokensToSend, 
            tokensToSend, 
            options, 
            "", 
            "" 
        ); 
 
        // Quote the send fee 
        MessagingFee memory fee = iAdapter.quoteSend(sendParam, false); 
        console.log("Native fee: %d", fee.nativeFee);  
 
        // Send the tokens 
        iAdapter.send{value: fee.nativeFee}(sendParam, fee, signer); 
 
        console.log("Tokens bridged successfully!"); 
    } 
}