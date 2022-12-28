//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Charity{

struct charityOrganization{
  string charityName;
  address charityAddress;
  string Desc;
}
charityOrganization public charity;

struct Payment{
   string description;
   uint amount;
   address receiver;
   bool completed;


}
struct Product{
    string productId;
    string productName;
    uint price;
    address seller;
}

struct CoopStore{
  string StoreName;
  address StoreAddress;
  uint[] products;
}
struct Donator{
    address donatorAddress;
    string donarname;
    //amount of donation
    uint amount;
    uint projectId;
}

struct Request{
    uint Id;
    string description;
    uint fundAmount;
    address account;
    bool succsess;
    uint votesCount;
    uint totalvotes;
    uint projectId;
    
}
struct Benificiary{
    uint Id;
    address account;
}

struct Project{
    uint Id;
    string description;
    uint goalAmount;
    uint benificiaryId;
    uint[] ProjectRequests;
}

Donator[] public donators;
//mapping(address=>Donator) public donators;

Project[] public projects;
Payment[] public payments;
Product[] public products;
Request[] public requests;
Benificiary[] public beneficiaries;
mapping (uint=>address[])public donatorsOfProjects;// projectid => donators 
mapping(uint => mapping(address =>bool))public aprovals;//what request| who aproves it
CoopStore public coStore;

constructor(){

      charity = charityOrganization("charityOf3Musketry",msg.sender,"Genuine Charity App");
}
function Genuine_Charity_DApp() public {  

      products[0] = Product("0","Computer",10,msg.sender);
      products[1]  = Product("1","Laptop",20,msg.sender);
      products[2] = Product("2","Food",5,msg.sender);
      products[3]  = Product("3","Books",3,msg.sender);

   //   coStore = CoopStore("Genuine_Charity_Cooperative_Store",msg.sender,products);

}

function add_product(string memory id,string memory product_name,uint price) public{
    products[products.length] = Product(id,product_name,price,msg.sender);
}

function charityPayProject(uint pId)public payable{
    require(msg.sender==charity.charityAddress);
    payable(beneficiaries[projects[pId].benificiaryId].account).transfer(projects[pId].goalAmount);
}
    
function creatDonator(string memory name ,uint amount,uint pId)public {
    require(amount>0);
    Donator memory newD= Donator(msg.sender,name,amount,pId);
    donators.push(newD);
    donatorsOfProjects[pId].push(msg.sender);
}

function make_donation(uint donatorID)public payable{
    require(donators[donatorID].donatorAddress==msg.sender);
    payable(charity.charityAddress).transfer(donators[donatorID].amount);
}

function creatBenificiary()public{
    Benificiary memory newBenificiary = Benificiary(beneficiaries.length,msg.sender);
    beneficiaries.push(newBenificiary);
}

function benificiaryCreateProject(string memory description, uint benificiaryId, uint goalAmount)public{
    uint[] memory allRequests;
    Project memory newProject=Project(projects.length,description,goalAmount,benificiaryId,allRequests);
    projects.push(newProject);

}

function donarotVotesRequset(uint requestId,bool vote)public{
//seach in the donators of this project 
    uint pId=requests[requestId].projectId;
    address[] memory allDonators=donatorsOfProjects[pId];

    require(!aprovals[requestId][msg.sender]);
    for (uint i = 0; i < allDonators.length; i++) {
        if(allDonators[i]==msg.sender)
        aprovals[requestId][msg.sender]=vote;
    }


    requests[requestId].totalvotes++;
    if(vote==true){
        requests[requestId].votesCount++;}

}

function createFundingBeneficiaryRequest(string memory description, uint fundAmount,uint benificiaryID,uint projectId) public {
    Request memory newRequest = Request(requests.length,description,fundAmount,beneficiaries[benificiaryID].account,false,0,0,projectId);
    requests.push(newRequest);

}

function beneficiaryGetMoney(uint requestId) public payable{
    //if enough votes - > pay beneficiary 
//    requests[requestId].fundedAmount+=amount;
    require(requests[requestId].votesCount>=(requests[requestId].totalvotes/2));
        if (msg.sender == charity.charityAddress){
            // pay money to benficiary
            payable(requests[requestId].account).transfer(requests[requestId].fundAmount);
            requests[requestId].succsess=true;
        }
}
   function withdraw(uint256 amount) public payable{
        // This forwards 2300 gas, which may not be enough if the recipient
        // is a contract and gas costs change.
        payable(msg.sender).transfer(amount);}
}