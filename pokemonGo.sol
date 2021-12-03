// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Ownable.sol";
import "./ERC721.sol";

contract PokemonGo is Ownable, ERC721 {

    struct Pokemon {
      string name;
      uint dna;
      uint place;
      uint16 level;
      uint16 winCount;
      uint16 lossCount;
      bool tradable;
    }

    Pokemon[] public pokemons;
    uint create_fee = 0.001 ether;
    //mapping (uint => address) _owners;
    //mapping (address => uint) _balances;
    mapping (uint => uint) placecount;
    
    constructor() ERC721("PokemonGoToken","PGT") public{
        _createPokemon("The First One", 1, 1);
    }

    event NewPokemon(uint pokemonId, string name, uint dna, uint place);

    function _createPokemon(string memory _name, uint _dna, uint _place) internal {
        pokemons.push(Pokemon(_name, _dna, _place, 1, 0, 0,true));
        uint tokenId = pokemons.length -1;
        _mint(msg.sender,tokenId);
        emit NewPokemon(tokenId, _name, _dna, _place);
    }

    function createRandomPokemon(string memory _name, uint _place) public payable{
        // require(msg.value >= create_fee);
        //require(_balances[msg.sender] == 0);
        // payable(address(this)).transfer(msg.value);
        uint randDna =(uint(keccak256(bytes(_name))) + block.timestamp) % 3; // starting pokemon dna 0,1,2
        _createPokemon(_name, randDna, _place);
    }

    function returnPokemonsByUser(address _user) public view returns(uint[] memory) {
        uint[] memory result = new uint[](_balances[_user]);
        uint counter = 0;
        for (uint i = 0; i < pokemons.length; i++) {
            if (_owners[i] == _user) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

    function returnPokemonsByPlace(uint _place) public view returns(uint[] memory) {
        uint[] memory result = new uint[](placecount[_place]);
        uint counter = 0;
        for (uint i = 0; i < pokemons.length; i++) {
            if (pokemons[i].place == _place) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

    function setCreateFee(uint fee) external onlyOwner {
        create_fee = fee;
    }

    // function withdraw(uint x) external onlyOwner {
    //     payable(owner()).transfer(x);
    // }

    function returnPokemonById(uint id) public view returns(Pokemon memory){
        return pokemons[id];
    }

}
