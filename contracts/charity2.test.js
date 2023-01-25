const Web3 = require('web3');
const web3 = new Web3("http://localhost:8545");

const charity = artifacts.require("Charity");
var chai = require("chai");
const { assert } = require('chai');
//var chaiAsPromised = require("chai-as-promised");
//chai.use(chaiAsPromised);

const expect = chai.expect;
let account;


before(async() => {
  Charity= await charity.new();

  accounts = await web3.eth.getAccounts();

//  console.log("OK");

});
contract("Charity Test2", async accounts => {
   // const [ initialHolder, recipient, anotherAccount ] = accounts;

    
  it("createFundingBeneficiaryRequest & project",async () => {
    console.log("request description:");

    await Charity.creatBenificiary({from:accounts[1]});
    await Charity.benificiaryCreateProject("Project0",0,2,{from:accounts[1]});
    await Charity.createFundingBeneficiaryRequest('request 1', 2, 0,0,{ from:accounts[1]});

    const requests = await Charity.requests;
    console.log("request description:",requests(0).description,requests(0).account);
   // assert.strictEqual('request 1', request.description);

   });
 
    it("create donators  and donate",async () => {
      //3 ether or wei/account 2 is donator / project 0 is selected now 

//      let amount=web3.utils.toWei('1','ether');
      const donator0 = await Charity.creatDonator('donator 0',web3.utils.toWei( web3.utils.toBN(3), "ether"),0,{ from:accounts[2]});
      await Charity.make_donation(0,{from:accounts[2],value:web3.utils.toWei( web3.utils.toBN(3), "ether")});

      const donator1 = await Charity.creatDonator('donator 1',web3.utils.toWei( web3.utils.toBN(4), "ether"),0,{ from:accounts[2]});
      await Charity.make_donation(0,{from:accounts[2],value:web3.utils.toWei( web3.utils.toBN(4), "ether")});

      assert.ok(donator0);
      assert.ok(donator1);
    });

 
    
    it("charity pay for project",async () => {

      await Charity.charityPayForProject(0,{from:accounts[1]});

      let balance = await web3.eth.getBalance(accounts[1]);
     // balance = web3.utils.fromWei(balance, 'ether');
      //balance = parseFloat(balance);
      console.log("account remaining\n",balance);
  
    });

 it("donarotVotesRequset",async () => {
 
       await Charity.donarotVotesRequset(0,true,{from:accounts[0]});
       await Charity.donarotVotesRequset(0,true,{from:accounts[1]});
     });

  it("charity pay beneficiary the requested money",async () => {

    await Charity.beneficiaryGetMoney(0,{ from:accounts[1] });

    let balance = await web3.eth.getBalance(accounts[1]);
    balance = web3.utils.fromWei(balance, 'ether');
    balance = parseFloat(balance);
    console.log("account remaining:",balance);
  });

  it("create store and products",async () => {
    await Charity.creatCooStore("store0",{from:accounts[0]});
    await Charity.add_product("book",2,0,5,{from:accounts[0]});
    assert("OK")
  });

  it("beneficiary buy product",async () => {
    await Charity.benificiaryBuyProduct(0,0,0,1,{from:accounts[1]});
  });

  it("withdraw from the store",async () => {
    await Charity.withdraw(0,{from:accounts[1]});
  });
});

