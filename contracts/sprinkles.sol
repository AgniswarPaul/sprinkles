pragma solidity ^0.4.0;

import "https://github.com/souradeep-das/sprinkles/node_modules/zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";
import "https://github.com/souradeep-das/sprinkles/node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol";

contract sprinkles is ERC721Token, Ownable {
  using SafeMath for uint256;


 struct room{
   uint status;
   address firstplayer;
   address secondplayer;
   uint cardid1;
   uint cardid2;
   address winner;
 }

 mapping (address => room) usertoroom;


  mapping (address => uint) userstatus;
  mapping (address => string) userchoice;
  mapping (address => uint) cardstaked;

  string public constant name = "Sprink";
  string public constant symbol = "SPR";

  constructor() ERC721Token(name,symbol) public{

  }

  function createCardSet5(uint a) public payable {
      require(msg.value>= 0.008 ether);
      for(uint i=0;i<5;i++)
      {
         uint8 rand2 = uint8(uint256(keccak256(a, block.difficulty))%5);
         createToken(rand2);
         a=a+7;

      }
      userstatus[msg.sender]=0;
  }

  function createCardSet10(uint a) public payable {
      require(msg.value>=0.02 ether);
      for(uint i=0;i<9;i++)
      {
        uint8 rand2 = uint8(uint256(keccak256(a, block.difficulty))%5);
         createToken(rand2);
         a=a+49;
      }
      createToken(7);
      userstatus[msg.sender]=0;
  }


  string _tokentype;
  function createToken(uint num) public {

    if(num==1)
    {
        _tokentype="ChocoChip";
    }
    else if(num==2)
    {
        _tokentype="Caramel";
    }
    else if(num==3)
    {
        _tokentype="Peppermint";
    }
    else if(num==4)
    {
       _tokentype="Vanilla Scoop";
    }
    else
    {
       _tokentype="Dixie Pixies";
    }
    mint(msg.sender,_tokentype);
  }

bytes32 ad = "0x";
// 1 = active 2 = not
  function startbattle(address player2,uint card1,uint card2) public {
    usertoroom[msg.sender] = room(1,msg.sender,player2,card1,card2,player2);
  }

  function endbattle() public {
    usertoroom[msg.sender].status = 2;
    transferFrom(msg.sender,usertoroom[msg.sender].secondplayer,usertoroom[msg.sender].cardid1);
    createSpecialToken(usertoroom[msg.sender].secondplayer);
  }
  function createSpecialToken(address towner) public {
    mint(towner,"Dragon Card");
  }

  function createSpecialToken2() public {
    mint(msg.sender,"Golden Combo");
  }

  function mint(address _to,string _tokenURI) internal {
    uint256 newTokenId = _getNextTokenId();
    _mint(_to,newTokenId);
    _setTokenURI(newTokenId,_tokenURI);
  }

  function _getNextTokenId() private view returns(uint256){
    return totalSupply().add(1);
  }

  function mergemytokens(uint id1,uint id2) {
    require(tokenOwner[id1] == msg.sender);
    require(tokenOwner[id2] == msg.sender);
    uint8 rand2 = uint8(uint256(keccak256(block.number, block.difficulty))%4);
     createToken(rand2);
     _burn(msg.sender,id1);
     _burn(msg.sender,id2);

  }

  function GenerateIcecream(uint a,uint b, uint c, uint d) {
    createSpecialToken2();
    _burn(msg.sender,a);
    _burn(msg.sender,b);
    _burn(msg.sender,c);
    _burn(msg.sender,d);

  }

  /* function GenerateIcecream(uint a,uint b, uint c) {
    createSpecialToken2();
    _burn(msg.sender,a);
    _burn(msg.sender,b);
    _burn(msg.sender,c);

  }

  function GenerateIcecream(uint a,uint b) {
    createSpecialToken2();
    _burn(msg.sender,a);
    _burn(msg.sender,b);

  } */

  function getMyTokens() external view returns(uint256[]){
    return ownedTokens[msg.sender];
  }

  function getcardformat(uint cardid) view returns(uint,string){
      return (cardid,tokenURI(cardid));
  }

 function () payable{

 }

}
