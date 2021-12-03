// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./pokemonGo.sol";

contract PokemonHelper is PokemonGo {

    mapping(uint => uint) gardians;
    uint levelup_fee = 0.001 ether;
    
    function challenge(uint id, uint place) external payable{
        require(_owners[id] == msg.sender);
        require(pokemons[id].place == )
        require(msg.value > 0.001 ether);
        payable(address(_owners[gardians[place]])).transfer(msg.value/2);
        if(gardians[place] == 0)
            gardians[place] = id;

        else if(fight(id,gardians[place])){
            pokemons[gardians[place]].lossCount +=1;
            pokemons[id].winCount+=1;
            gardians[place] = id;
        }
        else{
            pokemons[gardians[place]].winCount +=1;
            pokemons[id].lossCount+=1;
        }
    }

    function getGardian(uint place) public view returns(uint){
        return gardians[place];
    }


    function fight(uint id1, uint id2) private returns(bool){
        if(id1 > id2)
            return true;
        else
            return false;
    }

    function levelUp(uint id) external payable{
        require(msg.value > levelup_fee);
        pokemons[id].level++;
    }

    function transferFrom(address from, address to, uint256 tokenId) public override {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        require(pokemons[tokenId].tradable);

        _transfer(from, to, tokenId);
    }

    function getLevel(uint id) external view returns(uint16){
        return pokemons[id].level;
    }

    function getName(uint id) external view returns(string memory){
        return pokemons[id].name;
    }

    function changeName(uint id, string memory name) external {
        require(msg.sender == _owners[id]);
        pokemons[id].name = name;
    }

    function changePlace(uint id, uint place) external {
        require(msg.sender == _owners[id]);
        pokemons[id].place = place;
    }

    function setLevelUpFee(uint fee) external onlyOwner{
        levelup_fee = fee;
    }
}
