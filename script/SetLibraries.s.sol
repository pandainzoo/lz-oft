// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

// Forge imports
import "forge-std/console.sol";
import "forge-std/Script.sol";

// LayerZero imports
import { ILayerZeroEndpointV2 } from "@layerzerolabs/lz-evm-protocol-v2/contracts/interfaces/ILayerZeroEndpointV2.sol";

contract SetLibraries is Script {
    function run(address _endpoint, address _oapp, uint32 _eid, address _sendLib, address _receiveLib, address _signer, uint256 _gracePeriod) external {
        // Initialize the endpoint contract
        ILayerZeroEndpointV2 endpoint = ILayerZeroEndpointV2(_endpoint);

        // Start broadcasting transactions
        vm.startBroadcast(_signer);

        // Set the send library
        endpoint.setSendLibrary(_oapp, _eid, _sendLib);
        console.log("Send library set successfully.");

        // Set the receive library
        endpoint.setReceiveLibrary(_oapp, _eid, _receiveLib, _gracePeriod);
        console.log("Receive library set successfully.");

        // Stop broadcasting transactions
        vm.stopBroadcast();
    }
}