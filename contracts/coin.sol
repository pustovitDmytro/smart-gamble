pragma solidity ^0.4.11;

contract Coin {

    address public owner;
    mapping (address => uint) balances;
    uint course = 100;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    modifier overdraft(uint coins) {
        require(balances[msg.sender] >= coins);
        _;
    }
    function Coin(){
        owner = msg.sender;
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
