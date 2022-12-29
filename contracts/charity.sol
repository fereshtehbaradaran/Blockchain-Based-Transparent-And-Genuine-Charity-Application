//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/utils/Strings.sol";

contract Charity{

struct charityOrganization{
  string charityName;
  address charityAddress;
  string Desc;
}

charityOrganization public charity;

struct Payment_token{
    uint tokenId;
   string description;
   uint amount;
   address receiver;
  // bool sold;
}
struct Product{
    uint productId;
    string productName;
    uint price;
    uint count;
}

struct CoopStore{
    uint storeId;
  string storeName;
  address storeAddress;
 // uint[] products;
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
  //  uint[] tokens;
}


struct Project{
    uint Id;
    string description;
    uint goalAmount;
    uint benificiaryId;
    uint[] ProjectRequests;
    bool succsess;
}

Donator[] public donators;
//mapping(address=>Donator) public donators;

Project[] public projects;
Payment_token[] public payments;
Product[] public products;
CoopStore []public stores;
Request[] public requests;
Benificiary[] public beneficiaries;
mapping (uint=>address[])public donatorsOfProjects;// projectid => donators 
mapping(uint => mapping(address =>bool))public aprovals;//what request| who aproves it
CoopStore public coStore;

function createCharity(address addr)public{
     charity = charityOrganization("charityOf3Musketry",addr,"Genuine Charity App");
}
function testProducts() pure public {  
      Product[] memory products_;
      products_[0] = Product(0,"Computer",10,2);
      products_[1]  = Product(1,"Laptop",20,3);
      products_[2] = Product(2,"Food",5,1);
      products_[3]  = Product(3,"Books",3,9);

   // coStore = CoopStore("Genuine_Charity_Cooperative_Store",msg.sender,products);

}

function benificiaryBuyProduct(uint beneficiaryId,uint storeId,uint productId,uint amount)public payable{
    require(products[productId].count>=amount  && amount>0);
    require(msg.sender==beneficiaries[beneficiaryId].account);
    payable(stores[storeId].storeAddress).transfer(amount*products[productId].price);
    Payment_token memory newToken=Payment_token(payments.length,Strings.toString(storeId),amount*products[productId].price,msg.sender);
    payments.push(newToken);


}
function creatCooStore(string memory name)public{
    require(msg.sender==charity.charityAddress);
    uint [] memory allProducts;
//    uint [] memory unsoledTs;
    CoopStore memory newStore=CoopStore(stores.length,name,charity.charityAddress);
    stores.push(newStore);
}

function add_product(string memory product_name,uint price,uint storeId,uint count) public{
    require(msg.sender==charity.charityAddress);
    require(count>0);
    Product memory newProduct = Product(products.length,product_name,price,count);
   // stores[storeId].products.push(products.length);
    products.push(newProduct);
}

function charityPayForProject(uint pId)public payable{
    require(msg.sender==charity.charityAddress);
    require(!projects[pId].succsess);
    payable(beneficiaries[projects[pId].benificiaryId].account).transfer(projects[pId].goalAmount);
    projects[pId].succsess=true;
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
//    uint[] memory tokens;
    Benificiary memory newBenificiary = Benificiary(beneficiaries.length,msg.sender);
    beneficiaries.push(newBenificiary);
}

function benificiaryCreateProject(string memory description, uint benificiaryId, uint goalAmount)public{
    uint[] memory allRequests;
    Project memory newProject=Project(projects.length,description,goalAmount,benificiaryId,allRequests,false);
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
    projects[projectId].ProjectRequests.push(newRequest.Id);
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
   function withdraw(uint tokenId) public payable{
        require(msg.sender==charity.charityAddress && payments[tokenId].receiver!=charity.charityAddress);
        payable(payments[tokenId].receiver).transfer(payments[tokenId].amount);
        payments[tokenId].receiver=charity.charityAddress;
        }
}