// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.6;

import {ChildNFT} from "./ChildNFT.sol";
import {ERC721Base} from "./ERC721Base.sol";
import {ERC721BaseFactory} from "./ERC721BaseFactory.sol";

contract ChildNFTWithBase is ChildNFT, ERC721Base {
    constructor() ChildNFT(ERC721BaseFactory(address(0x0)), "", "", 0) {}
}
