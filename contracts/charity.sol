//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Charity{

struct charityOrganization{
  string charityName;
  address charityAddress;
  string Desc;
}
charityOrganization public charity;

struct Donator{
    address donatorAddress;
    string donarname;
    //amount of donation
    uint amount;
    //which project?
    uint projectId;


}
Donator[] public donators;

struct Request{
    string description;
    uint goalAmount;
    uint fundedAmount;
    address account;
    bool succsess;
    uint votesCount;
}
Request[] public requests;
mapping(uint => mapping(address =>bool))aprovals;//what request| who aproves it

constructor(){
      charity = charityOrganization("charityOf3Musketry",msg.sender,"Genuine Charity App");
      
}

function transfor(address to,uint amount)public payable returns(bool){
    if(msg.value>=amount){
        payable(to).transfer(amount);
     return true;
    }
    return false;
}
function directDonation(string memory name ,uint amount, uint pId)public{
    Donator memory newD= Donator(msg.sender,name, amount, pId);
    if(true==transfor(charity.charityAddress,amount)){
        donators.push(newD);
    }

}
function payBeneficiary(uint id)public {
    
}
function voitingDonation(uint requestIndex)public{
    //if enough votes - > pay beneficiary 

}

function createFundingBeneficiaryRequest(string memory description, uint goalAmount, address account) public {
    Request memory newRequest = Request(description,goalAmount, 0,account,false,0);
    requests.push(newRequest);
}

}