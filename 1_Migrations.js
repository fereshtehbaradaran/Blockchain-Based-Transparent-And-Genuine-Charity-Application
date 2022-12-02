const Migrations = artifacts.require("Migrations");

module.exports = function(deployer){
    deployer.deployed(Migrations);
}