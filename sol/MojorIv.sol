// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";



contract MojorFreeMintServer is ERC721, ERC721URIStorage,Ownable {

    event addMintAccountEvent      (address  ads);

    mapping(address => uint) public accounts;

    mapping(address => bool) public agreeAddress;

    address[] public whiteList;

    bytes32 public lotteryParmOne;

    address[] public winner;

    uint public no=0;

    constructor() ERC721("Mojor Free Mint", "Mojor Free Mint") {
    }

    function safeMint(string memory uri)
    public
    {
        require(accounts[msg.sender]==0,"can only be mint once");
        require(agreeAddress[msg.sender],"no qualified for Minting");
        _safeMint(msg.sender, no);
        _setTokenURI(no, uri);
        no++;
        accounts[msg.sender]=1;
        lotteryParmOne=blockhash(block.number -1);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
    public
    view
    override(ERC721, ERC721URIStorage)
    returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function isParticipate(address account) public view returns(bool){
        if(accounts[account] >0){
            return true;
        }
        return false;
    }

    function getNumber(bytes32 _hash) public view returns(uint8) {
        for(uint8 i = _hash.length - 1;i >= 0;i--){
            uint8 b = uint8(_hash[i]) % 16;
            if(b>=0 && b<10) return b;
            uint8 c = uint8(_hash[i]) / 16;
            if(c>=0 && c<10) return c;
        }
    }


    function isValid(address account) public view returns(bool){
        return agreeAddress[account];
    }


    function test() public view returns(uint){
        return whiteList.length;
    }


    function addMintAccount(address[7]  memory addrs) public  onlyOwner{
        for(uint i = 0; i < addrs.length; i++){
            agreeAddress[addrs[i]]=true;
            emit addMintAccountEvent(addrs[i]);
        }
    }

}