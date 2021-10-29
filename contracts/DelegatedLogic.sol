// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.9;

import {IBaseInterface} from "./IBaseInterface.sol";
import {ERC721Base} from "./ERC721Base.sol";

contract DelegatedLogic {
    uint256[100000] private ______gap;
    address public nftImplementation;

    constructor(
        IBaseInterface _nftImplementation,
        string memory name,
        string memory symbol,
        uint16 royaltyBps
    ) {
        nftImplementation = address(_nftImplementation);
        (bool success, ) = nftImplementation.delegatecall(
            abi.encodeWithSignature(
                "initialize(address,string,string,uint16)",
                msg.sender,
                name,
                symbol,
                royaltyBps
            )
        );
        require(success, "Success");
    }

    modifier onlyOwner() {
        require(msg.sender == _owner(), "Not owner");
        _;
    }

    function _owner() internal view returns (address) {
        return IBaseInterface(address(this)).owner();
    }

    function _burn(uint256 id) internal {
        IBaseInterface(address(this)).burn(id);
    }

    // function _tokenURI(uint256 id) internal pure returns (string memory) {
    //     // return IBaseInterface(address(this)).tokenURI(id);
    //     return "";
    // }

    function _mint(address to, uint256 id) internal {
        IBaseInterface(address(this)).mint(to, id);
    }

    function _exists(uint256 id) internal view returns (bool) {
        return IBaseInterface(address(this)).exists(id);
    }

    function _isApprovedOrOwner(address operator, uint256 id)
        internal
        view
        returns (bool)
    {
        return IBaseInterface(address(this)).isApprovedOrOwner(operator, id);
    }

    /// Set the base URI of the contract. Allowed only by parent contract
    function _setBaseURI(string memory newUri) internal {
        IBaseInterface(address(this)).setBaseURI(newUri);
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
            let result := delegatecall(gas(), impl, 0, calldatasize(), 0, 0)

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
