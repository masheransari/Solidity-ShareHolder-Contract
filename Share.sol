// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

contract Share{
    struct EthShare{
        address partnerAddress;
        uint amount;
        bool isWithdrawl;
    }

    uint withDrawlCount = 0;

    uint minimumEth =  1 ether;

    mapping(address =>EthShare) shareHolderMapping;

    function depositEther() public payable{
        require(msg.value>=minimumEth,"Minimum invest required around (1 ETher)");
        shareHolderMapping[msg.sender] = EthShare(msg.sender,msg.value,false);
        // return msg.value;
    } 

    function getInfo() public view returns(EthShare memory){
        return shareHolderMapping[msg.sender];
    }

    function getWithdrawlShare() public returns (uint) {
        require(withDrawlCount<3,"No one can withdrawl now");
        require(!shareHolderMapping[msg.sender].isWithdrawl,"Share already withdrawl");
        uint amount = shareHolderMapping[msg.sender].amount;
        shareHolderMapping[msg.sender].isWithdrawl = true;
        require(amount>=minimumEth,"Sorry no amount exists");
        
        uint transferAmount = 0;
        uint sharedAmountPerPercentage = shareHolderMapping[msg.sender].amount / 100;
        if (withDrawlCount == 0){
            transferAmount = sharedAmountPerPercentage * 90;
        } else if (withDrawlCount == 1){
            transferAmount = sharedAmountPerPercentage * 80;
        } else if (withDrawlCount == 2){
            transferAmount = sharedAmountPerPercentage * 70;            
        }
        
        payable(msg.sender).transfer(transferAmount);
        shareHolderMapping[msg.sender].amount = 0;
        withDrawlCount++;
        return transferAmount;
    }


}