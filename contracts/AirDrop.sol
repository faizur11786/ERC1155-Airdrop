//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract AirDrop is Ownable, ReentrancyGuard {
    using Address for address;

    struct Drop {
        uint256 eligibleNFT;
        uint256 airDropedNFT;
    }

    mapping(address => Drop) public airDrops;
    address[] public airDropAccounts;
    address public erc1155;
    address public payer;

    constructor(address _erc1155, address _payer) Ownable() ReentrancyGuard() {
        erc1155 = _erc1155;
        payer = _payer;
    }

    function addAirDrops(
        address[] memory _candidates,
        uint256[] memory _NFTId
    ) external onlyOwner {
        require(
            _candidates.length == _NFTId.length,
            "Array length mismatch"
        );
        for (uint256 i; i < _candidates.length; i++) {
            airDrops[_candidates[i]].eligibleNFT += _NFTId[i];
            if( indexOf(airDropAccounts, _candidates[i]) < 0 ){
                airDropAccounts.push(_candidates[i]);
            }
        }
    }

    function addEth() external payable {}

    function airdropAccountsLength() external view returns (uint256 length) {
        return airDropAccounts.length;
    }

    function airDropTokens(address account) public onlyOwner nonReentrant {
        _airDropToAccount(account);
    }

    function batchAirDropTokens(address[] memory accounts)
        public
        onlyOwner
        nonReentrant
    {
        for (uint256 i; i < accounts.length; i++) {
            _airDropToAccount(accounts[i]);
        }
    }

    function airDropToAllEligible() public onlyOwner nonReentrant {
        for (uint256 i; i < airDropAccounts.length; i++) {
            _airDropToAccount(airDropAccounts[i]);
        }
    }


    function _airDropToAccount(address _account) internal {
        uint256 tokenId = airDrops[_account].eligibleNFT;
        airDrops[_account].eligibleNFT -= tokenId;
        airDrops[_account].airDropedNFT += tokenId;
        IERC1155(erc1155).safeTransferFrom(payer, _account, tokenId, 1,"");
    }

    function indexOf(address[] memory arr, address searchFor)
        internal
        pure
        returns (int)
    {
        for (uint256 i = 0; i < arr.length; i++) {
            if (arr[i] == searchFor) {
                return int(i);
            }
        }
        return -1; // not found
    }

    function withdraw(address _token, uint256 tokenId) public onlyOwner nonReentrant {
        IERC1155 acceptedToken = IERC1155(_token);
        acceptedToken.safeTransferFrom(address(this), owner(), tokenId, 1, "");
    }

    function withdraw() public onlyOwner nonReentrant {
        Address.sendValue(payable(owner()), address(this).balance);
    }
}
