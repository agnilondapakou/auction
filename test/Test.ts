import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import hre from "hardhat";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";


describe("Lock", function () {
  async function deployAuction() {
    const [seller, otherAccount] = await hre.ethers.getSigners();

    const token = await hre.ethers.getContractFactory("OurIERC20");
    const tokenInstance = await token.deploy();

    const auction_duration = await time.duration.seconds(60 * 60 * 24 * 365); 

    const Auction = await hre.ethers.getContractFactory("Auction");
    const auction = await Auction.deploy(tokenInstance.target, seller.address, 1200, auction_duration, 10, 100000);

    return { auction, seller, otherAccount, tokenInstance };
  }

  describe("Deployment", function () {
    it("Should deploy the contract", async function () {
      const { auction } = await deployAuction();
      expect(auction.target).to.not.equal(0);
    });

    it("Should check if the seller is the address o", async function () {
      const { seller } = await deployAuction();
      expect(seller.address).to.not.equal(0);
    })
  });

  describe("Start auction", function () {
    it("Should start the auction", async function () {
      const { auction, tokenInstance } = await deployAuction();

      // mint tokens 
      await tokenInstance.mint(auction, 100000);

      await auction.startAuction();
      expect(auction.startTime).to.not.equal(0);
    })
  });
});
