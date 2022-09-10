// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

contract Share{
    struct EthShare{
        address partnerAddress;
        uint amount;
        bool isWithdrawl;
        uint timeStamp;
    }

    uint oneMonthTotalTimeStamp = 5000;
    uint withDrawlCount = 0;

    uint minimumEth =  1 ether;

    mapping(address =>EthShare) shareHolderMapping;

    function depositEther() public payable{
        require(msg.value>=minimumEth,"Minimum invest required around (1 ETher)");
        // 25
        shareHolderMapping[msg.sender] = EthShare(msg.sender,msg.value,false, block.timestamp);
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
    
        uint differenceTime = block.timestamp - shareHolderMapping[msg.sender].timeStamp;
        uint transferAmount = 0;
        uint sharedAmountPerPercentage = shareHolderMapping[msg.sender].amount / 100;
        // if (withDrawlCount == 0){
        //     transferAmount = sharedAmountPerPercentage * 90;
        // } else if (withDrawlCount == 1){
        //     transferAmount = sharedAmountPerPercentage * 80;
        // } else if (withDrawlCount == 2){
        //     transferAmount = sharedAmountPerPercentage * 70;            
        // }

        //This is for seconds for now.
        // if (differenceTime == 10){ //hold for 10 second
        //     transferAmount = sharedAmountPerPercentage * 110;
        // } else if (differenceTime == 11){//hold for 11 second
        //     transferAmount = sharedAmountPerPercentage * 120;
        // } else if (differenceTime == 12){//hold for 12 second
        //     transferAmount = sharedAmountPerPercentage * 130;
        // } else if (differenceTime == 13){//hold for 13 second
        //     transferAmount = sharedAmountPerPercentage * 140;
        // } else if (differenceTime == 14){//hold for 14 second
        //     transferAmount = sharedAmountPerPercentage * 150;
        // } else if (differenceTime == 15){//hold for 15 second
        //     transferAmount = sharedAmountPerPercentage * 160;
        // }

        //This is for Months for staking token now.


        uint secondData = 2592000; //Amount for second per one month 
        if (differenceTime < secondData){
            transferAmount = sharedAmountPerPercentage * 100;
        }else if (differenceTime < secondData * 2 ){
            transferAmount = sharedAmountPerPercentage * 110;
        } else if (differenceTime < secondData * 3){
            transferAmount = sharedAmountPerPercentage * 120;
        } else if (differenceTime < secondData * 4){
            transferAmount = sharedAmountPerPercentage * 130;
        } else if (differenceTime < secondData * 5){
            transferAmount = sharedAmountPerPercentage * 140;
        } else if (differenceTime < secondData * 6){
            transferAmount = sharedAmountPerPercentage * 150;
        } else if (differenceTime < secondData * 7){
            transferAmount = sharedAmountPerPercentage * 160;
        }

        payable(msg.sender).transfer(transferAmount);
        shareHolderMapping[msg.sender].amount = 0;
        withDrawlCount++;
        return transferAmount;
    }
}