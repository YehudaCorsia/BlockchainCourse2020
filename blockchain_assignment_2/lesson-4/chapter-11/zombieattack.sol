pragma solidity ^0.4.25;

import "./zombiehelper.sol";

contract ZombieAttack is ZombieHelper {
  uint randNonce = 0;
  /*If you're the attacking zombie, you will have a 70% chance of winning.
   The defending zombie will have a 30% chance of winning.*/
  uint attackVictoryProbability = 70;

  /*
  What this would do is take the timestamp of now,
  the msg.sender, and an incrementing nonce
  (a number that is only ever used once, so we don't run the same hash function with the same input parameters twice).

  It would then "pack" the inputs and use keccak to convert them to a random hash.
  Next, it would convert that hash to a uint, and then use % 100 to take only the last 2 digits.
  This will give us a totally random number between 0 and 99.
  
  This method is vulnerable to attack by a dishonest node*/
  function randMod(uint _modulus) internal returns(uint) {
    randNonce++;
    return uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % _modulus;
  }

  function attack(uint _zombieId, uint _targetId) external ownerOf(_zombieId) {
     /*get a storage pointer to both zombies so we can more easily interact with them:*/
    Zombie storage myZombie = zombies[_zombieId];
    Zombie storage enemyZombie = zombies[_targetId];
    /*We're going to use a random number between 0 and 99 to determine the outcome of our battle.
     So declare a uint named rand, and set it equal to the result of the randMod function with 100 as an argument.*/
    uint rand = randMod(100);
    /*If the attacking zombie wins, it levels up and spawns a new zombie.*/
    if (rand <= attackVictoryProbability) {
      myZombie.winCount++;
      myZombie.level++;
      enemyZombie.lossCount++;
      feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
    } /*If it loses, nothing happens (except its lossCount incrementing).*/
    else {
      myZombie.lossCount++;
      enemyZombie.winCount++;
      /*This way the zombie can only attack once per day.
       (Remember, _triggerCooldown is already run inside feedAndMultiply. So the zombie's cooldown will be triggered whether he wins or loses.)*/
      _triggerCooldown(myZombie);
    }

  }
}
