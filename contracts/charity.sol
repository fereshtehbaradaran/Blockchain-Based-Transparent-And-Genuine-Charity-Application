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
    uint256 tokenId;
   string description;
   uint256 amount;
   address receiver;
   uint256 productId;
  // bool sold;
}
struct Product{
    uint256 productId;
    string productName;
    uint256 price;
    uint256 count;
    uint256 storeId;
}

struct CoopStore{
    uint256 storeId;
  string storeName;
  address storeAddress;
 // uint256[] products;
}

struct Donator{
    address donatorAddress;
    string donarname;
    //amount of donation
    uint256 amount;
    uint256 projectId;
}

struct Request{
    uint256 Id;
    string description;
    uint256 fundAmount;
    address account;
    bool succsess;
    uint256 votesCount;
    uint256 totalvotes;
    uint256 projectId;
    
}
struct Benificiary{
    uint256 Id;
    address account;
  //  uint256[] tokens;
}
struct Project{
    uint256 Id;
    string description;
    uint256 goalAmount;
    uint256 benificiaryId;
    uint256[] ProjectRequests;
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
mapping (uint256=>address[])public donatorsOfProjects;// projectid => donators 
mapping(uint256 => mapping(address =>bool))public aprovals;//what request| who aproves it
CoopStore public coStore;

function createCharity(address addr)public{
     charity = charityOrganization("charityOf3Musketry",addr,"Genuine Charity App");
}
function testProducts() pure public {  
      Product[] memory products_;
      products_[0] = Product(0,"Computer",10,2,0);
      products_[1]  = Product(1,"Laptop",20,3,0);
      products_[2] = Product(2,"Food",5,1,0);
      products_[3]  = Product(3,"Books",3,9,0);

   // coStore = CoopStore("Genuine_Charity_Cooperative_Store",msg.sender,products);

}

function benificiaryBuyProduct(uint256 beneficiaryId,uint256 storeId,uint256 productId,uint256 amount)public payable{
    require(products[productId].count>=amount  && amount>0);
    require(msg.sender==beneficiaries[beneficiaryId].account);

    payable(stores[storeId].storeAddress).transfer(amount*products[productId].price);
    
    Payment_token memory newToken=Payment_token(payments.length,Strings.toString(storeId),amount*products[productId].price,msg.sender,productId);
    payments.push(newToken);


}
function creatCooStore(string memory name)public{
   // require(msg.sender==charity.charityAddress);
   // uint256 [] memory allProducts;
//    uint256 [] memory unsoledTs;
    CoopStore memory newStore=CoopStore(stores.length,name,charity.charityAddress);
    stores.push(newStore);
}

function add_product(string memory product_name,uint256 price,uint256 storeId,uint256 count) public{
 //   require(msg.sender==charity.charityAddress);
    require(count>0);
    Product memory newProduct = Product(products.length,product_name,price,count,storeId);
    products.push(newProduct);
}

function charityPayForProject(uint256 pId)public{
    require(msg.sender== beneficiaries[projects[pId].benificiaryId].account);
    require(projects[pId].succsess==true);
    (bool callSuccess,)=payable(msg.sender).call{value:projects[pId].goalAmount}("");
    require(callSuccess);
//    payable(beneficiaries[projects[pId].benificiaryId].account).transfer(projects[pId].goalAmount);
    projects[pId].succsess=true;
}
    
function creatDonator(string memory name ,uint256 amount,uint256 pId)public {
    require(amount>0);
    Donator memory newD= Donator(msg.sender,name,amount,pId);
    donators.push(newD);
    donatorsOfProjects[pId].push(msg.sender);
}

function make_donation(uint256 donatorID)public payable{
    require(donators[donatorID].donatorAddress==msg.sender);
    payable(charity.charityAddress).transfer(donators[donatorID].amount);
    if(donators[donatorID].amount>=projects[donators[donatorID].projectId].goalAmount)
        projects[donators[donatorID].projectId].succsess=true;
}

function creatBenificiary()public{
//    uint256[] memory tokens;
    Benificiary memory newBenificiary = Benificiary(beneficiaries.length,msg.sender);
    beneficiaries.push(newBenificiary);
}

function benificiaryCreateProject(string memory description, uint256 benificiaryId, uint256 goalAmount)public{
    uint256[] memory allRequests;
    Project memory newProject=Project(projects.length,description,goalAmount,benificiaryId,allRequests,false);
    projects.push(newProject);

}

function donarotVotesRequset(uint256 requestId,bool vote)public{
//seach in the donators of this project 
    uint256 pId=requests[requestId].projectId;
    address[] memory allDonators=donatorsOfProjects[pId];

    require(!aprovals[requestId][msg.sender]);
    for (uint256 i = 0; i < allDonators.length; i++) {
        if(allDonators[i]==msg.sender)
        aprovals[requestId][msg.sender]=vote;
    }

    requests[requestId].totalvotes++;
    if(vote==true){
        requests[requestId].votesCount++;}

}

function createFundingBeneficiaryRequest(string memory description, uint256 fundAmount,uint256 benificiaryID,uint256 projectId) public {
    Request memory newRequest = Request(requests.length,description,fundAmount,beneficiaries[benificiaryID].account,false,0,0,projectId);
    requests.push(newRequest);
    projects[projectId].ProjectRequests.push(newRequest.Id);
}

function beneficiaryGetMoney(uint256 requestId) public payable{
    //if enough votes - > pay beneficiary 
//    requests[requestId].fundedAmount+=amount;
    require(requests[requestId].votesCount>=(requests[requestId].totalvotes/2));
      if (msg.sender == requests[requestId].account){
            // pay money to benficiary
            (bool callSuccess,)=payable(msg.sender).call{value:msg.value}("");
            require(callSuccess);
            requests[requestId].succsess=true;
        }
}
   function withdraw(uint256 tokenId) public{
        require(payments[tokenId].receiver!=charity.charityAddress);
        require(payments[tokenId].receiver==msg.sender);
        (bool callSuccess,)=payable(msg.sender).call{value:payments[tokenId].amount}("");
        require(callSuccess);
        //payable(payments[tokenId].receiver).transfer(payments[tokenId].amount);
        payments[tokenId].receiver=charity.charityAddress;
        products[payments[tokenId].productId].count+=1;
        }
}