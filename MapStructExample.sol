pragma solidity ^0.5.10;

contract MapStructExample {
    
    struct Payment {
        uint amount;
        uint timestamp;
    }
    
    struct Balance {
        uint totalBalance;
        uint numPayments;
        mapping(uint => Payment) payments;
    }
    
    mapping(address => Balance) public mapAccounts;
    
    function getBalance() public view returns(uint) {
        return mapAccounts[msg.sender].totalBalance;
    }
    
    function sendMoney() payable public {
        mapAccounts[msg.sender].totalBalance += msg.value;
    }
    
    function withdrawAllMoney() public {
        uint moneyToSend = mapAccounts[msg.sender].totalBalance;
        mapAccounts[msg.sender].totalBalance = 0;
        mapAccounts[msg.sender].payments[mapAccounts[msg.sender].numPayments] = Payment(mapAccounts[msg.sender].totalBalance, now);
        mapAccounts[msg.sender].numPayments++;
        address(msg.sender).send(moneyToSend);
    }
    
    function withdrawMoney(uint money) public {
        require(mapAccounts[msg.sender].totalBalance >= money);
        mapAccounts[msg.sender].totalBalance -= money;
        mapAccounts[msg.sender].payments[mapAccounts[msg.sender].numPayments] = Payment(money, now);
        mapAccounts[msg.sender].numPayments++;
        address(msg.sender).send(money);
    }
    
}