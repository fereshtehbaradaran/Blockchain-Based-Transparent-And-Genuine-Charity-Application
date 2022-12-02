const Token = artifacts.require("Token");
contract("Token",(accounts) =>{
    before(async()=>{
      token = await Token.deployed()  
    })
    it("check  ",async()=>{
       let balance=await token.balanceOf(accounts[0])

       // console.log(balance)
    })


})