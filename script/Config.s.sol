// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

// Forge imports
import "forge-std/console.sol";
import "forge-std/Script.sol";

// LayerZero imports
import { ExecutorConfig } from "@layerzerolabs/lz-evm-messagelib-v2/contracts/SendLibBase.sol";
import { ILayerZeroEndpointV2 } from "@layerzerolabs/lz-evm-protocol-v2/contracts/interfaces/ILayerZeroEndpointV2.sol";
import { OFT } from "@layerzerolabs/oft-evm/contracts/OFT.sol";
import { SetConfigParam } from "@layerzerolabs/lz-evm-protocol-v2/contracts/interfaces/IMessageLibManager.sol";
import { UlnConfig } from "@layerzerolabs/lz-evm-messagelib-v2/contracts/uln/UlnBase.sol";

contract Config is Script {
    uint32 public constant EXECUTOR_CONFIG_TYPE = 1;
    uint32 public constant ULN_CONFIG_TYPE = 2;

    function getConfig(address _endpoint,address _oapp, address _lib, uint32 remoteEid) external view {
        ILayerZeroEndpointV2 endpoint = ILayerZeroEndpointV2(_endpoint);
        bytes memory receiveUlnConfigBytes = endpoint.getConfig(_oapp, _lib, remoteEid, ULN_CONFIG_TYPE);

        UlnConfig memory config = abi.decode(receiveUlnConfigBytes, (UlnConfig));
        console.log("confirmations: %d",config.confirmations);
        console.log("requiredDVNCount: %d",config.requiredDVNCount);
        console.log("optionalDVNCount: %d",config.optionalDVNCount);
        console.log("optionalDVNThreshold: %d",config.optionalDVNThreshold);
        console.log("requiredDVNs:");
        for (uint256 i; i < config.requiredDVNs.length; i++) {
            console.logAddress(config.requiredDVNs[i]);
        }
        console.log("optionalDVNs:");
        for (uint256 i; i < config.optionalDVNs.length; i++) {
            console.logAddress(config.optionalDVNs[i]);
        }
    }

    function setConfig(address _endpoint,address oapp,  address lib, address[] memory DVNs, uint32 remoteEid, uint64 confirmations) external {
        ILayerZeroEndpointV2 endpoint = ILayerZeroEndpointV2(_endpoint);
        address[] memory requiredDVNs = new address[](DVNs.length); // place LZ DVN at start, switch to Mantle's in the future
        address[] memory optionalDVNs = new address[](0);

        for (uint256 i; i < DVNs.length; i++) {
            requiredDVNs[i] = DVNs[i];
        }

        UlnConfig memory config = UlnConfig({
            confirmations: confirmations,
            requiredDVNCount: uint8(requiredDVNs.length),
            requiredDVNs: requiredDVNs,
            optionalDVNThreshold: 0,
            optionalDVNCount: uint8(optionalDVNs.length),
            optionalDVNs: optionalDVNs
        });

        SetConfigParam memory scp = SetConfigParam({
            eid: remoteEid,
            configType: ULN_CONFIG_TYPE,
            config: abi.encode(config)
        });
        SetConfigParam[] memory setConfigParams = new SetConfigParam[](1);
        setConfigParams[0] = scp;

        uint256 privateKey = vm.envUint("PRIVATE_KEY"); 
        vm.startBroadcast(privateKey); 
        endpoint.setConfig(oapp, lib, setConfigParams);
        vm.stopBroadcast();
    }
}