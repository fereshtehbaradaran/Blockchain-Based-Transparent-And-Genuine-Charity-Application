const assert = require('assert');
const ganache = require('ganache-cli');
const Web3 = require('web3');
const provider = ganache.provider();
const web3 = new Web3(provider);
const {interface,bytecode} = require("../charity");

let accounts;
let contract;

beforeEach(async() => {
  // this.timeout(3000); // A very long environment setup.
  //  setTimeout(done, 2500);
  // get all accounts
  accounts = await web3.eth.getAccounts();

  // deplaoy the contract using one accounts
  contract = await new web3.eth.Contract(JSON.parse(interface))
  .deploy({ data: bytecode })
  .send({ from:accounts[0], gas:5000000 });

});

describe("Charity Org",() => {
  it("deploys a contract",() => {

    assert.ok(contract);
  });

  it("charity object",async () => {

    const obj = await contract.methods.charity().call();
    console.log(obj);
    assert.ok(obj);
  });

  it("allows createFundingBeneficiaryRequest",async () => {

   await contract.methods
     .createFundingBeneficiaryRequest('request 1', '500', accounts[2])
     .send({
        from:accounts[2],
        gas: '100000-'
       });
   const request = await contract.methods.requests(0).call();
   assert.strictEqual('request 1', request.description);
  });

   it("create donators",async () => {
     const hash1 = await contract.methods.createDonator('donar 1','').send({ from:accounts[1],gas:'2000000' });
     assert.ok(hash1);
   });

   it("make_donations",async () => {
     const hash2 = await contract.methods.donation(0).send({ from:accounts[1],gas:'2000000' }); // instead of 0 we pass project id
     assert.ok(hash2);
    });


    it("donarotVotesRequset ==> creat request",async () => {

    try {
      await contract.methods.donarotVotesRequset(0,true).send({
        value: '0.1',
        from: accounts[0]
      });
      assert(false);
    } catch (err){
      assert(err);
    }

   // });

      await contract.method.createFundingBeneficiaryRequest('books for childre', 500 , accounts[2]).send({ from: accounts[0], gas: '1000000' });

      let balance = await web3.eth.getBalance(accounts[1]);
      balance = web3.utils.fromWei(balance, 'ether');
      balance = parseFloat(balance);

      assert(balance > 100);
    });
    
    it("send money to beneficiary",async () => {

      const hash = await contract.methods.beneficiaryGetMoney(0).send({ from:accounts[0] }); // instead of 0 we pass payment id
      assert.ok(hash);

     });



});