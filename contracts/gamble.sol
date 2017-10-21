pragma solidity ^0.4.11;

contract Gamble {

    address public owner;
    mapping (address => uint) balances;
    mapping (address => uint) bets;
    mapping (address => uint) odds;
    uint course = 1000000000000;
    uint[] outcomes;
    uint precission=100;
    bool finished = false;
    uint winner;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    modifier overdraft(uint coins) {
        require(balances[msg.sender] >= coins);
        _;
    }
    function Gamble(uint number){
        owner = msg.sender;
        for (uint i=0;i<number;i++){
            outcomes.push(1);
        }
    }
    function getOdd(uint participant) returns(uint odd){
        uint sum = 0;
        for (uint i=0;i<outcomes.length;i++){
            sum+=outcomes[i];
        }
        return sum*precission/outcomes[participant];
    }
    function bet(uint coins, uint participant) overdraft(coins){
        address account = msg.sender;
        balances[account] -= coins;
        bets[account] = participant;
        outcomes[participant]+=coins;
        odds[account] = getOdd(participant) + coins*precission;
    }
    function finish(uint result) onlyOwner{
        for (uint i=0;i<outcomes.length;i++){
            outcomes[i] =0;
        }
        winner = result;
        finished = true;
    }
    function checkWin(){
        require (finished);
        address account = msg.sender;
        if (bets[account]==winner){
            balances[account] += odds[account]/precission;
        }
    }
    function buyCoins() payable {
        address account = msg.sender;
        uint weis = msg.value;
        uint coins = weis/course;
        balances[account] += coins;        
    }
    function sendCoins(address reciever, uint coins) overdraft(coins){
        address sender = msg.sender;
        balances[sender] -= coins;
        balances[reciever] += coins; 
    }
    function sellCoins(uint coins) overdraft(coins){
        address account = msg.sender;
        balances[account] -= coins;
        uint value = coins*course;
        account.transfer(value);
    }
    function getBalance() returns(uint balance) {
        balance = balances[msg.sender];       
    }
    function SetCourse(uint weis) onlyOwner {
        course = weis;
    }
}
