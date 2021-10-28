// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.6;

import {IBaseInterface} from "./IBaseInterface.sol";
import {ERC721BaseFactory} from "./ERC721BaseFactory.sol";

contract DelegatedLogic {
    IBaseInterface public nftImplementation;

    constructor(
        ERC721BaseFactory baseFactory,
        string memory name,
        string memory symbol,
        uint16 royaltyBps
    ) {
        nftImplementation = IBaseInterface(baseFactory.createNewChild(
            name,
            symbol,
            royaltyBps
        ));
    }

    modifier onlyOwner() {
        require(
            msg.sender == nftImplementation.owner(),
            "Not owner"
        );
        _;
    }

    /**
     * @dev Delegates the current call to the address returned by `_implementation()`.
     *
     * This function does not return to its internall call site, it will return directly to the external caller.
     */
    function _fallback() internal virtual {
        address impl = address(nftImplementation);

        assembly {
            // Copy msg.data. We take full control of memory in this inline assembly
            // block because it will not return to Solidity code. We overwrite the
            // Solidity scratch pad at memory position 0.
            calldatacopy(0, 0, calldatasize())

            // Call the implementation.
            // out and outsize are 0 because we don't know the size yet.
            let result := call(gas(), impl, 0, 0, calldatasize(), 0, 0)

            // Copy the returned data.
            returndatacopy(0, 0, returndatasize())

            switch result
            // delegatecall returns 0 on error.
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }

    /**
     * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
     * function in the contract matches the call data.
     */
    fallback() external payable virtual {
        _fallback();
    }
}
