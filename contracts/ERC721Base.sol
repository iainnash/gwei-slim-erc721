// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.6;

import {ERC721Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import {IERC2981Upgradeable, IERC165Upgradeable} from "@openzeppelin/contracts-upgradeable/interfaces/IERC2981Upgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {IBaseInterface} from "./IBaseInterface.sol";
import {ILogicContract} from "./ILogicContract.sol";

/**
    This is a smart contract for handling dynamic contract minting.

    @dev This allows creators to mint a unique serial edition of the same media within a custom contract
    @author iain nash
    Repository: https://github.com/ourzora/nft-editions
*/
contract ERC721Base is
    ERC721Upgradeable,
    IBaseInterface,
    IERC2981Upgradeable,
    OwnableUpgradeable
{
    ILogicContract public logicContract;
    uint256 private minted;
    uint16 public royaltyBps;

    /**
      @dev Function to create a new edition. Can only be called by the allowed creator
           Sets the only allowed minter to the address that creates/owns the edition.
           This can be re-assigned or updated later
     */
    function initialize(
        ILogicContract _logicContract,
        address newOwner,
        string memory _name,
        string memory _symbol,
        uint16 _royaltyBps
    ) public initializer {
        __ERC721_init(_name, _symbol);
        __Ownable_init();

        transferOwnership(newOwner);
        // Save logic contract here
        logicContract = _logicContract;

        royaltyBps = _royaltyBps;
    }

    /// @dev returns the number of minted tokens within the edition
    function totalSupply() public view returns (uint256) {
        return minted;
    }

    /**
      @param to address to send the newly minted edition to
      @dev This mints one edition to the given address by an allowed minter on the edition instance.
     */
    function mintFromLogic(address to, uint256 tokenId) external override {
        require(
            msg.sender == address(logicContract),
            "Needs to be an allowed minter"
        );
        _mint(to, tokenId);
        minted += 1;
    }

    /**
        @param tokenId Token ID to burn
        User burn function for token id 
     */
    function burn(uint256 tokenId) public override {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId) ||
                msg.sender == address(logicContract),
            "Not approved"
        );
        _burn(tokenId);
        minted -= 1;
    }

    /**
        Simple override for owner interface.
     */
    function owner()
        public
        view
        override(OwnableUpgradeable, IBaseInterface)
        returns (address)
    {
        return super.owner();
    }

    /**
        @dev Get royalty information for token
        @param _salePrice Sale price for the token
     */
    function royaltyInfo(uint256, uint256 _salePrice)
        external
        view
        override
        returns (address receiver, uint256 royaltyAmount)
    {
        if (owner() == address(0x0)) {
            return (owner(), 0);
        }
        return (owner(), (_salePrice * royaltyBps) / 10_000);
    }

    /**
        @dev Get URI for given token id
        @param tokenId token id to get uri for
        @return base64-encoded json metadata object
    */
    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(_exists(tokenId), "No token");

        // could do a try/catch then use the baseuri in this contract too
        return logicContract.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721Upgradeable, IERC165Upgradeable)
        returns (bool)
    {
        return
            type(IERC2981Upgradeable).interfaceId == interfaceId ||
            ERC721Upgradeable.supportsInterface(interfaceId);
    }
}
