pragma solidity ^0.4.25;

import "./zombieattack.sol";
import "./erc721.sol";
/*For preventing overflows*/ 
import "./safemath.sol";

/*using multiple inheritance*/
/// @title A contract for ZombieOwnership
/// @author Yehuda Corsia
/// @notice This is my first contract
contract ZombieOwnership is ZombieAttack, ERC721 {

  using SafeMath for uint256;

  mapping (uint => address) zombieApprovals;

  /*This function simply takes an address, and returns how many tokens that address owns.*/
  function balanceOf(address _owner) external view returns (uint256) {
    return ownerZombieCount[_owner];
  }

  /*This function takes a token ID (in our case, a Zombie ID), and returns the address of the person who owns it.*/
  function ownerOf(uint256 _tokenId) external view returns (address) {
    return zombieToOwner[_tokenId];
  }


  function _transfer(address _from, address _to, uint256 _tokenId) private {
    /*The first thing our function should do is increment ownerZombieCount for the person receiving the zombie (address _to)*/
    ownerZombieCount[_to] = ownerZombieCount[_to].add(1);
    /* decrease the ownerZombieCount for the person sending the zombie (address _from)*/
    ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender].sub(1);
    /*Lastly, we'll want to change zombieToOwner mapping for this _tokenId so it now points to _to.*/
    zombieToOwner[_tokenId] = _to;
    emit Transfer(_from, _to, _tokenId);
  }

  function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
      require (zombieToOwner[_tokenId] == msg.sender || zombieApprovals[_tokenId] == msg.sender);
      _transfer(_from, _to, _tokenId);
    }

  /*In the approve function, we want to make sure only the owner of the token can give someone approval to take it.
   So we need to add the onlyOwnerOf modifier to approve*/
  function approve(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId) {
      zombieApprovals[_tokenId] = _approved;
      emit Approval(msg.sender, _approved, _tokenId);
    }

}
