// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const AuctionModule = buildModule("AuctionModule", (m) => {

  const tokenAddress = 0x8F799354cccCA3cF61a51a376287AFEC3a4Bb7e4;
  const paymentAddress = 0x8F799354cccCA3cF61a51a376287AFEC3a4Bb7e4;
  const pricePerSecond = 100;
  const amountForSale = 100000;
  const initialPrice = 1200;
  const duration = 60 * 60 * 24 * 365;


  const auction = m.contract("Auction", [tokenAddress, paymentAddress, initialPrice, duration, pricePerSecond, amountForSale]);

  return { auction };
});

export default AuctionModule;