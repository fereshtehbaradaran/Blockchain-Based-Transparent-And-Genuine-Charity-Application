//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {

    address public minter;
event MintChanged(address indexed from , address to);

constructor() payable ERC20("Genuine Charity App", "GCA") {
        minter = msg.sender;
    }
function passMinterRole(address Charity) public returns (bool){
    require(msg.sender==minter,"Error,msg.sender is not the minter");
    minter=Charity;

    emit MintChanged(msg.sender, Charity);
    return true;
}
function mint(address account,uint256 amount)public{
    require(msg.sender==minter,"Error,msg.sender is not the minter");
    _mint(account,amount);
    }

}
