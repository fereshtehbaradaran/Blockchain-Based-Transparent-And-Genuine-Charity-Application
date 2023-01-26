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
contract("Charity unit test", async accounts => {
   // const [ initialHolder, recipient, anotherAccount ] = accounts;

    
  it("createFundingBeneficiary",async () => {

    await Charity.creatBenificiary({from:accounts[1]});
assert("ok");
   });

   
   it("create project",async () => {
    await Charity.benificiaryCreateProject("Project0",0,2,{from:accounts[1]});
    assert("OK");

   });

   it("create request",async () => {
    await Charity.createFundingBeneficiaryRequest('request 1', 2, 0,0,{ from:accounts[1]});
    assert("OK");
   });

   
    it("create donator func",async () => {

      const donator0 = await Charity.creatDonator('donator 0',web3.utils.toWei( web3.utils.toBN(8), "ether"),0,{ from:accounts[2]});
      assert.ok(donator0);
    });

 
    it("make a donation func",async () => {
        await Charity.make_donation(0,{from:accounts[2],value:web3.utils.toWei( web3.utils.toBN(8), "ether")});  
        assert("ok");
      });
    
 it("donarotVotesRequset function",async () => {
 
       await Charity.donarotVotesRequset(0,true,{from:accounts[0]});
       await Charity.donarotVotesRequset(0,true,{from:accounts[1]});
       assert("ok");
    });

  it("beneficiary GetMoney func",async () => {

    await Charity.beneficiaryGetMoney(0,{ from:accounts[1] });
    assert("ok");
  });

  it("create store ",async () => {
    await Charity.creatCooStore("store0",{from:accounts[0]});
    assert("OK")
  });

  it("create products",async () => {
    await Charity.add_product("book",web3.utils.toWei( web3.utils.toBN(2), "ether"),0,5,{from:accounts[0]});
    assert("OK")
  });


  it("beneficiary buy product func",async () => {
    await Charity.benificiaryBuyProduct(0,0,0,1,{value:web3.utils.toWei( web3.utils.toBN(2), "ether"),from:accounts[1]});
    assert("ok");
  });

});

