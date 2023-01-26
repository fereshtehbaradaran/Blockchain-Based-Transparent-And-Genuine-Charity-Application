/*const Charity = artifacts.require("charity");

module.exports = async function(deployer){

    await deployer.deployed(Charity); 
  //  let balance=token.balanceOf(accounts[0]);
    //console.log(balance);
}
*/
const Contacts = artifacts.require("../contacts/charity.sol");

module.exports = function(deployer) {
  deployer.deploy(Contacts);
};

/*const path = require('path');
const fs = require('fs');
const solc = require('solc');

const contractPath = path.resolve(__dirname,'contracts','charity.sol');
const source = fs.readFileSync(contractPath,'utf8');

console.log(solc.compile(source,1));
module.exports = solc.compile(source,1).contracts[':charityOrganization'];*/