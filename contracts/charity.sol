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
//Donator[] public donators;
mapping(address=>Donator) public donators;

struct Request{
    uint Id;
    string description;
    uint goalAmount;
    uint fundedAmount;
    address account;
    bool succsess;
    uint votesCount;
    uint totalvotes;
}
Request[] public requests;
mapping(uint => mapping(address =>bool))public aprovals;//what request| who aproves it
uint aprovalsLenght;

constructor(){
      charity = charityOrganization("charityOf3Musketry",msg.sender,"Genuine Charity App");
      aprovalsLenght=0;
}

function transfor(address to,uint amount)public payable returns(bool){
    if(msg.value>=amount){
        payable(to).transfer(amount);
     return true;
    }
    return false;
}
function creatDonator(string memory name ,uint amount, uint pId)public returns(Donator memory){
    Donator memory newD= Donator(msg.sender,name, amount, pId);
    donators[msg.sender]=newD;
    return newD;

}
function donation(uint amount)public payable returns(bool){
    if(msg.value>=amount){
        payable(charity.charityAddress).transfer(amount);
     return true;
    }
    return false;
}
function donarotVotesRequset(uint requestId,bool vote)public{
    // vote just vote no tranfer money for now
    require(!aprovals[requestId][msg.sender]);
    aprovals[requestId][msg.sender]=vote;
    requests[requestId].totalvotes++;
    if(vote==true)requests[requestId].votesCount++;

}

function createFundingBeneficiaryRequest(string memory description, uint goalAmount, address account) public {
    uint id = aprovalsLenght++;
    Request memory newRequest = Request(id,description,goalAmount, 0,account,false,0,0);
    requests.push(newRequest);
}

function beneficiaryGetMoney(uint requestId) public returns(bool){
    //if enough votes - > pay beneficiary 
//    requests[requestId].fundedAmount+=amount;
    if(requests[requestId].votesCount>=(requests[requestId].totalvotes/2)){
        //check if charity can transform the money
        if (msg.sender == charity.charityAddress){
            // pay money to benficiary
            payable(requests[requestId].account).transfer(requests[requestId].goalAmount);
            requests[requestId].succsess=true;
            return true;
            }
        return false;
    }
    return false;

}

}