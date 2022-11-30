const Token = artifacts.require("Token");

module.exports = async function(deployer){

    await deployer.deployed(Token); 
  //  let balance=token.balanceOf(accounts[0]);
    //console.log(balance);
}
