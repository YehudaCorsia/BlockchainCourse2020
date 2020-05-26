/*The verion of solidity compiler*/
pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {

    /*Define Event in solidiy  */
    event NewZombie(uint zombieId,string name,uint dna);
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    struct Zombie {
        string name;
        uint dna;
    }

    /* This means anyone (or any other contract) can call your contract's function and execute its code.*/
    Zombie[] public zombies;

    /* Memory define where the variable should be stored  */
    function _createZombie(string memory _name, uint _dna) private {
        zombies.push(Zumbie(_name, _dna));

        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        /*Fire the event */
        emit NewZombie(id, _name, _dna);
    } 
    /*View function, mean only viewing the data without modifying it:*/
    function _generateRandomDna(string memory _str) private view returns (uint) {
    /*Ethereum hash function keccak256 built in, version of SHA3.
     abi bytecode of the contract generate vy etheruim evm virtual */
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }
    function createRandomZombie(string memory _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}


