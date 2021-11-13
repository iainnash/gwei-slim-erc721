// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.9;

import {IBaseInterface} from "./IBaseInterface.sol";
import {ERC721Base, ConfigSettings} from "./ERC721Base.sol";

contract DelegatedLogic {
    // Reference to base NFT implementation
    ERC721Base public nftImplementation;

    /// Constructor that sets up the
    constructor(
        ERC721Base _nftImplementation,
        string memory name,
        string memory symbol,
        ConfigSettings memory settings
    ) {
        nftImplementation = _nftImplementation;
        /// Removed for gas saving reasons, the check below implictly accomplishes this
        // require(
        //     _nftImplementation.supportsInterface(
        //         type(IBaseInterface).interfaceId
        //     )
        // );
        (bool success, ) = address(_nftImplementation).delegatecall(
            abi.encodeWithSignature(
                "initialize(address,string,string,(uint16,string,string,bool))",
                msg.sender,
                name,
                symbol,
                settings
            )
        );
        require(success);
    }

    /// OnlyOwner implemntation that proxies to base ownable contract for info
    modifier onlyOwner() {
        require(msg.sender == base().owner(), "Not owner");
        _;
    }

    /// Getter to return the base implementation contract to call methods from
    function base() internal view returns (ERC721Base) {
        return ERC721Base(address(this));
    }

    // helpers to mimic Openzeppelin internal functions

    /// Internal burn function, only accessible from within contract
    /// @param id nft id to burn
    function _burn(uint256 id) internal {
        base().burn(id);
    }

    /// Internal mint function, only accessible from within contract
    /// @param to address to mint NFT to
    /// @param id nft id to mint
    function _mint(address to, uint256 id) internal {
        base().mint(to, id);
    }

    /// Internal exists function to determine if fn exists
    /// @param id nft id to check if exists
    function _exists(uint256 id) internal view returns (bool) {
        return base().exists(id);
    }

    /// Internal getter for approved or owner for a given operator
    /// @param operator address of operator to check
    /// @param id id of nft to check for
    function _isApprovedOrOwner(address operator, uint256 id)
        internal
        view
        returns (bool)
    {
        return base().isApprovedOrOwner(operator, id);
    }

    /// Sets the base URI of the contract. Allowed only by parent contract
    /// @param newUri new uri base (http://URI) followed by number string of nft followed by extension string
    /// @param newExtension optional uri extension
    function _setBaseURI(string memory newUri, string memory newExtension)
        internal
    {
        base().setBaseURI(newUri, newExtension);
    }

    /**
     * @dev Delegates the current call to nftImplementation.
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
    fallback() external virtual {
        _fallback();
    }

    /**
     * @dev No base NFT functions receive any value
     */
    receive() external payable {
        revert();
    }
}
