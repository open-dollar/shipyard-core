// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC721} from "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {OnchainTraits} from "./OnchainTraits.sol";
import {DynamicTraits} from "./DynamicTraits.sol";

contract ERC721OnchainTraits is OnchainTraits, ERC721 {
    constructor() ERC721("ERC721DynamicTraits", "ERC721DT") {
        _traitMetadataURI = "https://example.com";
    }

    function setTrait(uint256 tokenId, bytes32 traitKey, bytes32 value) external virtual override onlyOwner {
        // Revert if the token doesn't exist.
        _requireOwned(tokenId);

        _setTrait(tokenId, traitKey, value);
    }

    function getTraitValue(uint256 tokenId, bytes32 traitKey)
        public
        view
        virtual
        override
        returns (bytes32 traitValue)
    {
        // Revert if the token doesn't exist.
        _requireOwned(tokenId);

        return DynamicTraits.getTraitValue(tokenId, traitKey);
    }

    function getTraitValues(uint256 tokenId, bytes32[] calldata traitKeys)
        public
        view
        virtual
        override
        returns (bytes32[] memory traitValues)
    {
        // Revert if the token doesn't exist.
        _requireOwned(tokenId);

        return DynamicTraits.getTraitValues(tokenId, traitKeys);
    }

    function _isOwnerOrApproved(uint256 tokenId, address addr) internal view virtual override returns (bool) {
        return addr == ownerOf(tokenId) || isApprovedForAll(ownerOf(tokenId), addr) || getApproved(tokenId) == addr;
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, DynamicTraits) returns (bool) {
        return ERC721.supportsInterface(interfaceId) || DynamicTraits.supportsInterface(interfaceId);
    }
}
