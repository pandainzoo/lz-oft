// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

// Forge imports
import "forge-std/console.sol";
import "forge-std/Script.sol";

// LayerZero imports
import { ILayerZeroEndpointV2,IMessageLibManager } from "@layerzerolabs/lz-evm-protocol-v2/contracts/interfaces/ILayerZeroEndpointV2.sol";
import { SetConfigParam } from "@layerzerolabs/lz-evm-protocol-v2/contracts/interfaces/IMessageLibManager.sol";
import { UlnConfig } from "@layerzerolabs/lz-evm-messagelib-v2/contracts/uln/UlnBase.sol";

contract Config is Script {
    uint32 public constant EXECUTOR_CONFIG_TYPE = 1;
    uint32 public constant ULN_CONFIG_TYPE = 2;

    function getConfig(address _endpoint,address _oapp, address _lib, uint32 _remoteEid) external view {
        ILayerZeroEndpointV2 endpoint = ILayerZeroEndpointV2(_endpoint);
        bytes memory receiveUlnConfigBytes = endpoint.getConfig(_oapp, _lib, _remoteEid, ULN_CONFIG_TYPE);

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

    function setConfig(address _endpoint, address _oapp, address _lib, address[] memory _dvns, uint32 _remoteEid, uint64 _confirmations) external {
        ILayerZeroEndpointV2 endpoint = ILayerZeroEndpointV2(_endpoint);
        SetConfigParam[] memory setConfigParams = genSetConfigParam(_dvns, _remoteEid, _confirmations);

        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey); 
        endpoint.setConfig(_oapp, _lib, setConfigParams);
        vm.stopBroadcast();
    }

    function setConfigCalldata(address _oapp, address _lib, address[] memory _dvns, uint32 _remoteEid, uint64 _confirmations) external pure {
        SetConfigParam[] memory setConfigParams = genSetConfigParam(_dvns, _remoteEid, _confirmations);

        // abi.encodeWithSignature("setConfig(address,address,(uint32,uint32,bytes)[])", _oapp, _lib, setConfigParams);
        bytes memory callData = abi.encodeCall(IMessageLibManager.setConfig, (_oapp, _lib, setConfigParams));
        console.log("setConfig tx calldata:");
        console.logBytes(callData);
    }

    function genSetConfigParam(address[] memory _dvns, uint32 _remoteEid, uint64 _confirmations) public pure returns (SetConfigParam[] memory) {
        address[] memory requiredDVNs = new address[](_dvns.length);
        address[] memory optionalDVNs = new address[](0);

        for (uint256 i; i < _dvns.length; i++) {
            requiredDVNs[i] = _dvns[i];
        }

        UlnConfig memory config = UlnConfig({
            confirmations: _confirmations,
            requiredDVNCount: uint8(requiredDVNs.length),
            requiredDVNs: requiredDVNs,
            optionalDVNThreshold: 0,
            optionalDVNCount: uint8(optionalDVNs.length),
            optionalDVNs: optionalDVNs
        });

        SetConfigParam memory scp = SetConfigParam({
            eid: _remoteEid,
            configType: ULN_CONFIG_TYPE,
            config: abi.encode(config)
        });
        SetConfigParam[] memory setConfigParams = new SetConfigParam[](1);
        setConfigParams[0] = scp;
        return setConfigParams;
    }
}