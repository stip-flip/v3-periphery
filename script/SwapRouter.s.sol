pragma solidity >=0.7.6;

import '../contracts/SwapRouter.sol';
import '../contracts/lens/QuoterV2.sol';
import '../contracts/NonfungiblePositionManager.sol';
import '../contracts/NonfungibleTokenPositionDescriptor.sol';

import './lib/Strings.sol';
import 'forge-std/Script.sol';

function addressToString(address a) pure returns (string memory) {
    return String.toHexString(uint(uint160(a)), 20);
}

contract RouterScript is Script {
    address constant WETC9 = 0x1953cab0E5bFa6D4a9BaD6E05fD46C1CC6527a5a;
    function run() public {
        string memory path = string(abi.encodePacked('./addresses/63', '/router'));

        vm.startBroadcast();

        // SWAPS
        SwapRouter router = new SwapRouter(vm.envAddress('V3_FACTORY'), WETC9);

        vm.writeLine(path, 'ROUTER: ');
        vm.writeLine(path, addressToString(address(router)));

        QuoterV2 quoter = new QuoterV2(vm.envAddress('V3_FACTORY'), WETC9);

        vm.writeLine(path, 'QUOTER: ');
        vm.writeLine(path, addressToString(address(quoter)));

        // POSITIONS

        // token descriptor
        NonfungibleTokenPositionDescriptor tokenDescriptor = new NonfungibleTokenPositionDescriptor(
            WETC9,
            keccak256(abi.encodePacked('ETC'))
        );

        NonfungiblePositionManager positionManager = new NonfungiblePositionManager(
            vm.envAddress('V3_FACTORY'),
            WETC9,
            address(tokenDescriptor)
        );

        vm.writeLine(path, 'POSITION MANAGER: ');
        vm.writeLine(path, addressToString(address(positionManager)));

        vm.stopBroadcast();
    }
}
