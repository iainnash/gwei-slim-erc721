// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.6;

import {CountersUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import {ClonesUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/ClonesUpgradeable.sol";

contract ERC721BaseFactory {
    using CountersUpgradeable for CountersUpgradeable.Counter;
    CountersUpgradeable.Counter public atContract;
    ERC721Base public immutable baseContract;

    function constructor(ERC721Base _baseContract) {
        baseContract = _baseContract;
    }

    function createNewChild(uint16 _royaltyBps)
        external
        returns (IBaseInterface)
    {
        uint256 newId = atContract.current();
        address newContract = ClonesUpgradeable.cloneDeterministic(
            baseContract,
            bytes32(abi.encodePacked(newId))
        );
        ERC721Base(newContract).initialize(msg.sender, _royaltyBPS);
        atContract.increment();
        return newContract;
    }

    function getChildAtId(uint256 id) returns (ERC721Base) {
        return
            ERC721Base(
                ClonesUpgradeable.predictDeterministicAddress(
                    implementation,
                    bytes32(abi.encodePacked(id)),
                    address(this)
                )
            );
    }
}
