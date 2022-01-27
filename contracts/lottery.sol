pragma solidity ^0.8.0;
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
contract Lottery is VRFConsumerBase{

    address public owner;
    address[] public participants;
    bytes32 public keyHash;
    uint256 public fee;
    uint256 public randomResult;
    int private state;
    uint starttime;
    address public winner;




    constructor() VRFConsumerBase(0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B,0x01BE23585060835E02B77ef475b0Cc51aA1e0709){
        keyHash = 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;
        fee = 0.1 * 10 ** 18; //0.1
        owner = msg.sender;
        starttime = block.timestamp;
        getRandomNumber();


}
    modifier shouldOwner(){
        require(msg.sender==owner);
        _;
    }
    modifier validTime(){
        require(block.timestamp<=starttime+60 minutes);
        _;
    }

    modifier partfee(){
        require(msg.value == 0.1 ether);
        _;
    }
    modifier announcetime(){
        require(block.timestamp>starttime+60 minutes);
        _;
    }

    function getRandomNumber() internal returns (bytes32 requestId) {
        //require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet");
        return requestRandomness(keyHash, fee);
    }

    function registerParticipant() public payable partfee validTime  {
        participants.push(msg.sender);
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override{
        randomResult = randomness;
    }

    function announceWinner() private shouldOwner announcetime{

       uint win_id = (randomResult/participants.length)%participants.length;

        winner = participants[win_id];


    }
 
}