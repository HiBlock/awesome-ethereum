pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Adoption.sol";

contract TestAdoption {
    Adoption adoption = Adoption(DeployedAddresses.Adoption());

    //test adopt() function
    function testUserCanAdoptPet() public {
      uint returnedId = adoption.adopt(8);

      uint expected = 8;

      Assert.equal(returnedId, expected, "Adoption of Pet ID 8 should be recorded.");
    }

    //test retrieve of a single pet owner
    function testGetAdopterAddressByPetId() public {
      //expected owner is this contract
      address expected = this;
      address adopter = adoption.adopters(8);
      Assert.equal(adopter, expected, "owner of pet id 8 should be recorded.");
    }

    //test retrive of all pet owners
    function testGetAdopterAddressByPetIdInArray() public {
      //expected owner is this contract
      address expected = this;
      address[16] memory adopters = adoption.getAdopters();

      Assert.equal(adopters[8], expected, "owner of pet id 8 should be recorded.");
    }
}
