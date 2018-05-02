pragma solidity ^0.4.17;

contract Adoption {
    address[16] public adopters;

    //adopting a pet
    function adopt(uint petId) public returns (uint) {
      require(petId >= 0 && petId <= 15);
      adopters[petId] = msg.sender;
      return petId;
    }

    //retrieve the adopters
    function getAdopters() public view returns (address[16]) {
      return adopters;
    }
}
