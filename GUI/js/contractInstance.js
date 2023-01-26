  //contract instance
  var web3 = require('web3');
  var Contract = require('web3-eth-contract');

  const routes = require('./routes');

  var contractAddress = '0xf92837155D77cCCBc600326eE9CBb9007e2160AC';
  const CONTACT_ABI = require("../jsons/abi.json"); 
  const express = require('express');
  const app = express();
  const cors = require('cors');
  const Web3 = require('web3');
  const mongodb = require('mongodb').MongoClient;
  const contract = require('@truffle/contract');
 // const artifacts = require('../../build/contracts/Charity.json');
 
  const CONTACT_ADDRESS = contractAddress;
  
  app.use(cors());
  app.use(express.json());
  
  if (typeof web3 !== 'undefined') {
          var web3 = new Web3(web3.currentProvider); 
  } else {
          var web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));
  }
  
  mongodb.connect('mongodb://127.0.0.1:27017/blockchain-node-api',
          {
                  useUnifiedTopology: true,
          }, async (err, client) => {
          const db =client.db('Cluster0');
          const accounts = await web3.eth.getAccounts();
          const contactList = new web3.eth.Contract(CONTACT_ABI.CONTACT_ABI, CONTACT_ADDRESS.CONTACT_ADDRESS);
  
          routes(app, db, accounts, contactList);
          app.listen(process.env.PORT || 3001, () => {
                  console.log('listening on port '+ (process.env.PORT || 3001));
          });
  });