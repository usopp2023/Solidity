// SPDX-License-Identifier: MIT

/** 
* ====== Contributors =====

* alex🐋.eth#3436 -Issue Strategy Advisor
* 0x42B81011a367d3C7f4e4B570Fadd51209C93F287

* AugustFi.eth#8386 -Contract Advisor/Autitor
* 0xDc0Fb244722383BB12fB9970Bc46e60c94Fd78f7

* Dyson#2731- Idea/NFT Designer/Website Issuer
* 0xbe3018ec0a8D780833336251E591a58097d8618A

* fatfingererr#0697: Operation Advisor
* 0x7EA1EaA27b313D04D359bF3e654FE927376e31Bb

* SuanNai#5420-Media Coordinator
* 0xB8abE31a6caF1217D632190559B2C1FD909178ec

* Usopp#2531 -Contract Builder/Issuer
* 0x8817E259B93256bbb86DE6Cd2E9b8612763Cc674

* WODECHE#8546- Cheerleader
* 0x016df27C5a9e479AB01e3053CD5a1967f96eCD6E
* =============
*/ 

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract SeeDAO is ERC1155, Ownable{

    event OwnerMint(address indexed fromAddress,address indexed ownerMintAddress,uint256 indexed id,uint256 num,uint256 totalNum);
    event Mint(address indexed fromAddress, address indexed mintAddress,uint256 id);
    event Transfer(address indexed ownerAddress, address whitelistAddress);
    event Burn(address indexed fromAddress,uint256 indexed id,uint256 burnAmount);


    mapping (uint256 => mapping(address => bool)) public tokenIdAccountBool;
    mapping (uint256 => uint256) public totalSupply;
    mapping (uint256 => uint256) public mintedNumber;
    mapping (uint256 => uint256) public whitelistMinedNumber;
    string public name;
    string public symbol;
    address private _ownerAccount;
    string private _baseURI;
    
    constructor(string memory _name,string memory  _symbol,string memory _initialBaseURI) ERC1155(""){
        _baseURI = _initialBaseURI;
        name = _name;
        symbol = _symbol;
   

    }

    //铸造新 ID NFT
    function ownerMint(uint256 _tokenID,uint256 _amount,uint256 _totalSupply) public onlyOwner { 
        require( _totalSupply >= _amount,"Sorry,the number of totalAmount should higher than the amount!");
        
        _mint(msg.sender, _tokenID, _amount, "");
       
        totalSupply[_tokenID] += _totalSupply;
        mintedNumber[_tokenID] += _amount;

        _ownerAccount = msg.sender;

        emit OwnerMint(address(this),_ownerAccount,_tokenID,_amount,_totalSupply);
    } 


    //用户 mint NFT
    function mint(uint256 _tokenID) external{
        require(!tokenIdAccountBool[_tokenID][msg.sender],"Sorry,you already have one!");
        require(totalSupply[_tokenID] > mintedNumber[_tokenID],"Sorry, the NFT is zero!");
        
        tokenIdAccountBool[_tokenID][msg.sender] = true;
        mintedNumber[_tokenID] += 1;
        
        _mint(msg.sender,_tokenID,1,"");

        emit Mint(address(this),msg.sender,_tokenID);
    }

    //白名单空投（onlyOwner）
    function whitelistTransfer(address[] calldata _whitelistAccount,uint256 _tokenID) external onlyOwner{
        for (uint8 i;i<_whitelistAccount.length;i++){
            require(!tokenIdAccountBool[_tokenID][_whitelistAccount[i]],"Sorry,you already have one");
            require(totalSupply[_tokenID] > mintedNumber[_tokenID],"Sorry, the NFT is zero!");
            
            tokenIdAccountBool[_tokenID][_whitelistAccount[i]] = true;
            
            safeTransferFrom(_ownerAccount,_whitelistAccount[i],_tokenID,1,"");
            
            whitelistMinedNumber[_tokenID] += 1;

            emit Transfer(_ownerAccount,_whitelistAccount[i]);
        }
    }

    function uri(uint256 _tokenID) override public view returns (string memory) { 
        return(string(abi.encodePacked(_baseURI, Strings.toString(_tokenID),".json"))); 
    } 

    function setNewBaseURI(string memory _newBaseURI) external onlyOwner {
        _baseURI = _newBaseURI;
    }

    function burn(address from,uint256 _tokenID,uint256 _amount) external onlyOwner{
        _burn(from,_tokenID,_amount);
        totalSupply[_tokenID] -= _amount;
        
        emit Burn(from,_tokenID,_amount);
    }


}