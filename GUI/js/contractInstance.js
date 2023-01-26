  //contract instance
  var web3 = require('web3');
  var Contract = require('web3-eth-contract');


  var contractAddress = '0xf92837155D77cCCBc600326eE9CBb9007e2160AC';
  const  abi = require("../jsons/abi.json"); 
//  var contract = new Contract(abi, contractAddress);
const contract = new web3.eth.Contract(abi, contractAddress);
  // Accounts
  var account;
  
  web3.eth.getAccounts(function(err, accounts) {
    if (err != null) {
      alert("Error retrieving accounts.");
      return;
    }
    if (accounts.length == 0) {
      alert("No account found! Make sure the Ethereum client is configured properly.");
      return;
    }
    account = accounts[0];
    console.log('Account: ' + account);
    web3.eth.defaultAccount = account;
  });

