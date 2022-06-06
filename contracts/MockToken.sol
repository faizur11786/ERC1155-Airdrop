// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

/**
 * @title MarketToken contract
 * @dev Extends ERC1155 Token Standards
 */
contract MarketToken is ERC1155Supply, Ownable {
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    Counters.Counter public tokenIdCounter;

    mapping(uint => bool) public saleIsActive;

    bytes4 private constant INTERFACE_ID_ERC2981 = 0x2a55205a;
    // Tokens metadata hash in bytes
    mapping( uint => bytes ) internal _tokenUri;
    // base uri for JSON api host
    string public _uri;

    event TokenMint(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value, bytes data);

    constructor(string memory baseURI) ERC1155(baseURI) Ownable() {
        _uri = baseURI;
    }

    /**
     * Mints Bored Apes
     */
    function mint(uint256 numberOfTokens, bytes memory metaDataURI) public onlyOwner returns (uint) {
        uint256 _tokenId = tokenIdCounter.current();
        tokenIdCounter.increment();
        _tokenUri[_tokenId] = metaDataURI;
        _mint(msg.sender, _tokenId, numberOfTokens, metaDataURI);
        emit TokenMint(msg.sender, address(0), msg.sender, _tokenId, numberOfTokens, metaDataURI);
        return _tokenId;
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    function setURI(string memory newuri) public onlyOwner {
        _uri = newuri;
    }

    function uri(uint256 tokenId) override public view returns (string memory) {
        return string(_tokenUri[tokenId]);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155) returns (bool){
        if (interfaceId == INTERFACE_ID_ERC2981){
            return true;
        }
        return super.supportsInterface(interfaceId);
    }
}
