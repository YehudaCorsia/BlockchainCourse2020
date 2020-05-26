pragma solidity ^0.4.25;

// Import the second file zombiefactory for using it,
import "./zombiefactory.sol";

// This is the interface of CryptoKitties
contract KittyInterface {
  // external is similar to public, except that these functions can ONLY be called outside the contract
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

// This is the way of doing Inheritance in solidity
contract ZombieFeeding is ZombieFactory {

  // address of the CryptoKitties contract
  address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
  KittyInterface kittyContract = KittyInterface(ckAddress);

  function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) public {
    //That way new players will call it when they first start the game in order to create the initial zombie in their army
    //require makes it so that the function will throw an error and stop executing if some condition is not true
    // (Side note: Solidity doesn't have native string comparison, so we
    // compare their keccak256 hashes to see if the strings are equal)
    require(msg.sender == zombieToOwner[_zombieId]);

    // Storage refers to variables stored permanently on the blockchain
    Zombie storage myZombie = zombies[_zombieId];

    
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
      newDna = newDna - newDna % 100 + 99;
    }
    _createZombie("NoName", newDna);
  }

  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }

}