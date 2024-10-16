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
 
    //uint32 constant MANTLE_ENPOINT_ID = 40246; // mantle
    uint32 constant MANTLE_ENPOINT_ID = 40232; // op
    address constant SEPOLIA_MY_TOKEN = 0x49Da2478f5a3eE8f82aE569fFFe3Ce21Aa16E3f0;

    function setPeer() external { 
        address SEPOLIA_ADAPTER_ADDRESS = vm.envAddress( 
            "SEPOLIA_ADAPTER_ADDRESS" 
        ); 
        address MANTLE_OFT_ADDRESS = vm.envAddress("MANTLE_OFT_ADDRESS"); 
 
        uint256 privateKey = vm.envUint("PRIVATE_KEY"); 
        vm.startBroadcast(privateKey); 
 
        // Get the Adapter contract instance 
        IAdapter sepoliaAdapter = IAdapter(SEPOLIA_ADAPTER_ADDRESS); 
 
        // Hook up Sepolia Adapter to Mantle's OFT 
        sepoliaAdapter.setPeer( 
            MANTLE_ENPOINT_ID, 
            bytes32(uint256(uint160(MANTLE_OFT_ADDRESS))) 
        ); 
    } 


    function bridge() external { 
        address SEPOLIA_ADAPTER_ADDRESS = vm.envAddress( 
            "SEPOLIA_ADAPTER_ADDRESS" 
        ); 
        address MANTLE_OFT_ADDRESS = vm.envAddress("MANTLE_OFT_ADDRESS"); 
 
        uint256 privateKey = vm.envUint("PRIVATE_KEY"); 
        vm.startBroadcast(privateKey); 
        address signer = vm.addr(privateKey); 
 
        // Get the Adapter contract instance 
        IAdapter sepoliaAdapter = IAdapter(SEPOLIA_ADAPTER_ADDRESS); 
 
        // Define the send parameters 
        uint256 tokensToSend = 0.0001 ether; 
 
        bytes memory options = OptionsBuilder 
            .newOptions() 
            .addExecutorLzReceiveOption(200000, 0); 
 
        SendParam memory sendParam = SendParam( 
            MANTLE_ENPOINT_ID, 
            bytes32(uint256(uint160(signer))), 
            tokensToSend, 
            tokensToSend, 
            options, 
            "", 
            "" 
        ); 
 
        // Quote the send fee 
        MessagingFee memory fee = sepoliaAdapter.quoteSend(sendParam, false); 
        console.log("Native fee: %d", fee.nativeFee); 
 
        // Approve the OFT contract to spend UNI tokens 
        IERC20(SEPOLIA_MY_TOKEN).approve( 
            SEPOLIA_ADAPTER_ADDRESS, 
            tokensToSend 
        ); 
 
        // Send the tokens 
        sepoliaAdapter.send{value: fee.nativeFee}(sendParam, fee, signer); 
 
        console.log("Tokens bridged successfully!"); 
    } 
}