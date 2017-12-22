/*
Author : Jimmy Paris
Date of creation : 22.12.2017

Simple votation with authorized ETH address
It's actualy a simple binary vote for like (choice 1 or choice 2)
Feel free to use or change this code as you want!

A bit of history :
I did this code at 1am something for a friend who was in need for a votation in his classroom,
To can vote and protest (or not) against a project and maybe change it for another.
Don't hesitate to message me if you see some possible corrections or ameliorations.

*/

pragma solidity ^0.4.11;

contract Ownable {
    
  address public owner;
  
  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }
}

contract Votation is Ownable
{
    
    mapping (address => bool) public membres; //Adresse -> true   (si il est membre)
    
    mapping (address => bool) public membresDejaVote; // Adresse -> true (si il a déja voter pour éviter les double votes)
    
    mapping (address => bool) public membresVotes; // Adresse -> true (si il veut annuler le projet TPG) false (si il veut ne pas annuler le projet TPG)
    
    
    uint public nbMembres;
    
    uint public nbTrueAnnule; // Nombre de vote pour annuler
    
    uint public nbFalseAnnule; // Nombre de votes pour ne pas annuler


    //Pour autoriser une adresse ETH à voter
    function ajouterMembre(address membre) onlyOwner{
        require(membres[membre] == false);
        membres[membre] = true;
        nbMembres++;
    }
    
    modifier onlyMember(){
        require(membres[msg.sender]);
        _;
    }
    
    //fonction à utilisée pour répondre à un round (on doit être membre)
    function voter(bool vote) onlyMember {
        
        
        require(membresDejaVote[msg.sender] == false); // Vérifier qu'il n'a pas déja voter (si non on rejet)
        
        membresVotes[msg.sender] = vote; // Stocker le vote (true ou false) lié à son adresse
        
       if (vote == true){
           nbTrueAnnule++; // Ajouter un vote pour annuler au total
       } else {
           nbFalseAnnule++; // Ajouter un vote pour ne pas annuler au total
       }
       
       membresDejaVote[msg.sender] = true; //Noter qu'il a désormais déja voté

    }
}
