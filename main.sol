pragma solidity ^0.4.19;

contract Exchange {
    
    mapping(string => Deal) deals;

    enum Status {Available, Waiting, Closed}
    
    struct Deal {
        string userId;
        uint256 priceInWei;
        Status status;
        address owner;
        string itemId;

    }
    
    event NewDeal(uint256 price, string _itemId);
    

    function makeDeal(uint256 _price, string _itemId) public {
        deals[_itemId] = Deal(_itemId, _price, Status.Available, msg.sender, "");
        emit NewDeal(_price, _itemId);
    }
    
    modifier inState (string _itemId, Status _status) {
        require(deals[_itemId].status == _status);
        _;
    }
    
    modifier enoughMoney(string _itemId) {
        require(msg.value >= deals[_itemId].priceInWei);
        _;

    }
    
    function getDeal(string _userId, string _itemId)
        inState(_itemId, Status.Available)
        enoughMoney(_itemId)
        public payable {
        deals[_itemId].status = Status.Waiting;
        deals[_itemId].userId = _userId;
    }
    
    function confirmDeal(string _itemId) 
        inState(_itemId, Status.Waiting) 
        public {
        // TODO: hontoni kakunin shitehoshi
        deals[_itemId].status = Status.Closed;
        deals[_itemId].owner.transfer(deals[_itemId].priceInWei / 2);
    }
}