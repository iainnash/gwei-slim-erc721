// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.9;

/// Additional features and functions assigned to the
/// Base721 contract for hooks and overrides
interface IBaseInterface {
    /*
     Exposing common NFT internal functionality for base contract overrides
     To save gas and make API cleaner this is only for new functionality not exposed in
     the core ERC721 contract
    */

    /// Mint an NFT. Allowed to mint by owner, approval or by the parent contract
    /// @param tokenId id to burn
    function burn(uint256 tokenId) external;

    /// Mint an NFT. Allowed only by the parent contract
    /// @param to address to mint to
    /// @param tokenId token id to mint
    function mint(address to, uint256 tokenId) external;

    /// Set the base URI of the contract. Allowed only by parent contract
    /// @param base base uri
    /// @param extension extension
    function setBaseURI(string memory base, string memory extension) external;

    /* Exposes common internal read features for public use */

    /// Token exists
    /// @param tokenId token id to see if it exists
    function exists(uint256 tokenId) external view returns (bool);

    /// Simple approval for operation check on token for address
    /// @param spender address spending/changing token
    /// @param tokenId tokenID to change / operate on
    function isApprovedOrOwner(address spender, uint256 tokenId)
        external
        view
        returns (bool);

    function owner() external view returns (address);
}
