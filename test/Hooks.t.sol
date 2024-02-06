// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

import "forge-std/Test.sol";

import "../src/libraries/Hooks.sol";
import "../src/interfaces/ILBHooks.sol";

contract HooksTest is Test {
    MockHooks public hooks;

    function setUp() public {
        hooks = new MockHooks();
    }

    function test_EncodeHooks(Hooks.Parameters memory parameters) public {
        vm.assume(parameters.hooks != address(0));

        bytes32 hooksParameters = Hooks.encode(parameters);

        assertEq(parameters.hooks, Hooks.decode(hooksParameters).hooks, "test_Hooks::1");
        assertEq(parameters.beforeSwap, Hooks.decode(hooksParameters).beforeSwap, "test_Hooks::2");
        assertEq(parameters.afterSwap, Hooks.decode(hooksParameters).afterSwap, "test_Hooks::3");
        assertEq(parameters.beforeFlashLoan, Hooks.decode(hooksParameters).beforeFlashLoan, "test_Hooks::4");
        assertEq(parameters.afterFlashLoan, Hooks.decode(hooksParameters).afterFlashLoan, "test_Hooks::5");
        assertEq(parameters.beforeMint, Hooks.decode(hooksParameters).beforeMint, "test_Hooks::6");
        assertEq(parameters.afterMint, Hooks.decode(hooksParameters).afterMint, "test_Hooks::7");
        assertEq(parameters.beforeBurn, Hooks.decode(hooksParameters).beforeBurn, "test_Hooks::8");
        assertEq(parameters.afterBurn, Hooks.decode(hooksParameters).afterBurn, "test_Hooks::9");
        assertEq(
            parameters.beforeBatchTransferFrom, Hooks.decode(hooksParameters).beforeBatchTransferFrom, "test_Hooks::10"
        );
        assertEq(
            parameters.afterBatchTransferFrom, Hooks.decode(hooksParameters).afterBatchTransferFrom, "test_Hooks::11"
        );
    }

    function test_CallHooks(
        Hooks.Parameters memory parameters,
        address account,
        bytes32[] calldata liquidityConfigs,
        uint256[] calldata ids
    ) public {
        parameters.hooks = address(hooks);
        bytes32 hooksParameters = Hooks.encode(parameters);

        hooks.reset();
        Hooks.beforeSwap(hooksParameters, account, account, false, bytes32(0));

        if (parameters.beforeSwap) {
            assertEq(
                keccak256(hooks.data()),
                keccak256(abi.encodeWithSelector(ILBHooks.beforeSwap.selector, account, account, false, bytes32(0))),
                "test_Hooks::1"
            );
        } else {
            assertEq(hooks.data().length, 0, "test_Hooks::2");
        }

        hooks.reset();
        Hooks.afterSwap(hooksParameters, account, account, false, bytes32(0));

        if (parameters.afterSwap) {
            assertEq(
                keccak256(hooks.data()),
                keccak256(abi.encodeWithSelector(ILBHooks.afterSwap.selector, account, account, false, bytes32(0))),
                "test_Hooks::3"
            );
        } else {
            assertEq(hooks.data().length, 0, "test_Hooks::4");
        }

        hooks.reset();
        Hooks.beforeFlashLoan(hooksParameters, account, account, bytes32(0));

        if (parameters.beforeFlashLoan) {
            assertEq(
                keccak256(hooks.data()),
                keccak256(abi.encodeWithSelector(ILBHooks.beforeFlashLoan.selector, account, account, bytes32(0))),
                "test_Hooks::5"
            );
        } else {
            assertEq(hooks.data().length, 0, "test_Hooks::6");
        }

        hooks.reset();
        Hooks.afterFlashLoan(hooksParameters, account, account, bytes32(0));

        if (parameters.afterFlashLoan) {
            assertEq(
                keccak256(hooks.data()),
                keccak256(abi.encodeWithSelector(ILBHooks.afterFlashLoan.selector, account, account, bytes32(0))),
                "test_Hooks::7"
            );
        } else {
            assertEq(hooks.data().length, 0, "test_Hooks::8");
        }

        hooks.reset();
        Hooks.beforeMint(hooksParameters, account, account, liquidityConfigs, bytes32(0));

        if (parameters.beforeMint) {
            assertEq(
                keccak256(hooks.data()),
                keccak256(
                    abi.encodeWithSelector(ILBHooks.beforeMint.selector, account, account, liquidityConfigs, bytes32(0))
                ),
                "test_Hooks::9"
            );
        } else {
            assertEq(hooks.data().length, 0, "test_Hooks::10");
        }

        hooks.reset();
        Hooks.afterMint(hooksParameters, account, account, liquidityConfigs, bytes32(0));

        if (parameters.afterMint) {
            assertEq(
                keccak256(hooks.data()),
                keccak256(
                    abi.encodeWithSelector(ILBHooks.afterMint.selector, account, account, liquidityConfigs, bytes32(0))
                ),
                "test_Hooks::11"
            );
        } else {
            assertEq(hooks.data().length, 0, "test_Hooks::12");
        }

        hooks.reset();
        Hooks.beforeBurn(hooksParameters, account, account, account, ids, ids);

        if (parameters.beforeBurn) {
            assertEq(
                keccak256(hooks.data()),
                keccak256(abi.encodeWithSelector(ILBHooks.beforeBurn.selector, account, account, account, ids, ids)),
                "test_Hooks::13"
            );
        } else {
            assertEq(hooks.data().length, 0, "test_Hooks::14");
        }

        hooks.reset();
        Hooks.afterBurn(hooksParameters, account, account, account, ids, ids);

        if (parameters.afterBurn) {
            assertEq(
                keccak256(hooks.data()),
                keccak256(abi.encodeWithSelector(ILBHooks.afterBurn.selector, account, account, account, ids, ids)),
                "test_Hooks::15"
            );
        } else {
            assertEq(hooks.data().length, 0, "test_Hooks::16");
        }

        hooks.reset();
        Hooks.beforeBatchTransferFrom(hooksParameters, account, account, account, ids, ids);

        if (parameters.beforeBatchTransferFrom) {
            assertEq(
                keccak256(hooks.data()),
                keccak256(
                    abi.encodeWithSelector(
                        ILBHooks.beforeBatchTransferFrom.selector, account, account, account, ids, ids
                    )
                ),
                "test_Hooks::17"
            );
        } else {
            assertEq(hooks.data().length, 0, "test_Hooks::18");
        }

        hooks.reset();
        Hooks.afterBatchTransferFrom(hooksParameters, account, account, account, ids, ids);

        if (parameters.afterBatchTransferFrom) {
            assertEq(
                keccak256(hooks.data()),
                keccak256(
                    abi.encodeWithSelector(
                        ILBHooks.afterBatchTransferFrom.selector, account, account, account, ids, ids
                    )
                ),
                "test_Hooks::19"
            );
        } else {
            assertEq(hooks.data().length, 0, "test_Hooks::20");
        }
    }

    function test_HooksZeroAddress(Hooks.Parameters memory parameters) public {
        parameters.hooks = address(0);
        bytes32 hooksParameters = Hooks.encode(parameters);

        assertEq(hooksParameters, bytes32(0), "test_HooksZeroAddress::1");
    }
}

contract MockHooks is ILBHooks {
    bytes public data;

    function getLbPair() external pure override returns (ILBPair) {
        return ILBPair(address(0));
    }

    function reset() public {
        delete data;
    }

    function beforeSwap(address, address, bool, bytes32) external override returns (bytes4) {
        data = msg.data;
        return this.beforeSwap.selector;
    }

    function afterSwap(address, address, bool, bytes32) external override returns (bytes4) {
        data = msg.data;
        return this.afterSwap.selector;
    }

    function beforeFlashLoan(address, address, bytes32) external override returns (bytes4) {
        data = msg.data;
        return this.beforeFlashLoan.selector;
    }

    function afterFlashLoan(address, address, bytes32) external override returns (bytes4) {
        data = msg.data;
        return this.afterFlashLoan.selector;
    }

    function beforeMint(address, address, bytes32[] calldata, bytes32) external override returns (bytes4) {
        data = msg.data;
        return this.beforeMint.selector;
    }

    function afterMint(address, address, bytes32[] calldata, bytes32) external override returns (bytes4) {
        data = msg.data;
        return this.afterMint.selector;
    }

    function beforeBurn(address, address, address, uint256[] calldata, uint256[] calldata)
        external
        override
        returns (bytes4)
    {
        data = msg.data;
        return this.beforeBurn.selector;
    }

    function afterBurn(address, address, address, uint256[] calldata, uint256[] calldata)
        external
        override
        returns (bytes4)
    {
        data = msg.data;
        return this.afterBurn.selector;
    }

    function beforeBatchTransferFrom(address, address, address, uint256[] calldata, uint256[] calldata)
        external
        override
        returns (bytes4)
    {
        data = msg.data;
        return this.beforeBatchTransferFrom.selector;
    }

    function afterBatchTransferFrom(address, address, address, uint256[] calldata, uint256[] calldata)
        external
        override
        returns (bytes4)
    {
        data = msg.data;
        return this.afterBatchTransferFrom.selector;
    }
}
