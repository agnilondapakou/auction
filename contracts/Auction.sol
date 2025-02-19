// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Auction {

    address public seller;
    IERC20 public token;
    IERC20 public paymentToken;
    uint256 public initialPrice;
    uint256 public startTime;
    uint256 public duration;
    uint256 public priceDropPerSecond;
    uint256 public amountForSale;
    bool public auctionEnded;

    event AuctionStarted(address indexed seller, uint256 initialPrice, uint256 duration);
    event TokensPurchased(address indexed buyer, uint256 price, uint256 amount);

    constructor(
        address _token,
        address _paymentToken,
        uint256 _initialPrice,
        uint256 _duration,
        uint256 _priceDropPerSecond,
        uint256 _amountForSale
    ) {
        require(_initialPrice > 0, "Initial price need to be greater than zero");
        require(_duration > 0, "Invalid duration");

        seller = msg.sender;
        token = IERC20(_token);

        paymentToken = IERC20(_paymentToken);
        initialPrice = _initialPrice;
        duration = _duration;
        priceDropPerSecond = _priceDropPerSecond;
        amountForSale = _amountForSale;
    }

    function startAuction() external {
        require(msg.sender == seller, "Only seller can open auction");
        require(startTime == 0, "Auction already started");

        startTime = block.timestamp;
        require(token.transferFrom(seller, address(this), amountForSale), "Token transfer failed");
        emit AuctionStarted(seller, initialPrice, duration);
    }

    function getCurrentPrice() public view returns (uint256) {
        if (startTime == 0) {
            return initialPrice;
        }
        uint256 elapsedTime = block.timestamp - startTime;
        if (elapsedTime >= duration) {
            return 0;
        }
        return initialPrice - (elapsedTime * priceDropPerSecond);
    }

    function buyTokens() external {
        require(startTime > 0, "Auction not started");
        require(!auctionEnded, "Auction already ended");
        
        uint256 currentPrice = getCurrentPrice();
        require(currentPrice > 0, "Auction has ended with price zero");
        require(paymentToken.transferFrom(msg.sender, seller, currentPrice), "Payment transfer failed");
        require(token.transfer(msg.sender, amountForSale), "Token transfer failed");
        
        auctionEnded = true;
        emit TokensPurchased(msg.sender, currentPrice, amountForSale);
    }
}