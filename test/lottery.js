const {expect} = require("chai");
const { ethers } = require("hardhat");
const { isCallTrace } = require("hardhat/internal/hardhat-network/stack-traces/message-trace");

describe("Lottery Contract", function (){

    let Lottery;
    let hardhatLottery;
    let owner;
    let p1;
    let p2;
    let p3;
    let p4;

    beforeEach(async function(){
        Lottery = await ethers.getContractFactory("Lottery");
        [owner,p1,p2,p3,p4] = await ethers.getSigners();
        hardhatLottery = await Lottery.deploy();
    });

    describe("Deployment", function (){
        
        it("Should set the right owner", async function(){
            console.log(p1.balance)
            
            expect(await hardhatLottery.owner()).to.equal(owner.address);
            
        });
        it("register participant", async function(){
            console.log(p1.balance)
            let newpart =  hardhatLottery.connect(p1);
            const options = {value: ethers.utils.parseEther("0.1")}
            let tx = await newpart.registerParticipants(options);
            await tx.wait()
            //console.log(toArray(hardhatLottery.participants))
            
            expect(toArray(hardhatLottery.participants)).length.to.equal(1);
            
        });        

    });
});