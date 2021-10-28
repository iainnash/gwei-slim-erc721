// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.6;

import {CountersUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import {ClonesUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/ClonesUpgradeable.sol";
import {ERC721Base} from "./ERC721Base.sol";
import {IBaseInterface} from "./IBaseInterface.sol";
import {ILogicContract} from "./ILogicContract.sol";

contract ERC721BaseFactory {
    using CountersUpgradeable for CountersUpgradeable.Counter;
    CountersUpgradeable.Counter public atContract;
    ERC721Base public immutable baseContract;

    constructor(ERC721Base _baseContract) {
        baseContract = _baseContract;
    }

    function createNewChild(
        address owner,
        string memory name,
        string memory symbol,
        uint16 _royaltyBps
    ) external returns (address) {
        uint256 newId = atContract.current();
        address newContract = ClonesUpgradeable.cloneDeterministic(
            address(baseContract),
            bytes32(abi.encodePacked(newId))
        );
        ERC721Base(newContract).initialize(
            ILogicContract(msg.sender),
            owner,
            name,
            symbol,
            _royaltyBps
        );
        atContract.increment();
        return newContract;
    }

    // function getChildAtId(uint256 id) external returns (ERC721Base) {
    //     return
    //         ERC721Base(
    //             ClonesUpgradeable.predictDeterministicAddress(
    //                 implementation,
    //                 bytes32(abi.encodePacked(id)),
    //                 address(this)
    //             )
    //         );
    // }
}
