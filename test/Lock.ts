import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import hre from "hardhat";

describe("Lock", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployFixture() {
 
    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await hre.ethers.getSigners();

    const FactoryManager = await hre.ethers.getContractFactory("TokenFactoryManager");
    const factoryManger = await FactoryManager.deploy(owner.address);

    const StandardToken = await hre.ethers.getContractFactory("StandardToken");
    const standardToken = await StandardToken.deploy("test token", "text", 18, hre.ethers.parseEther('10000'), owner.address, hre.ethers.parseEther("0.0001"), owner.address, {value: hre.ethers.parseEther("0.0001")});

    const Factory = await hre.ethers.getContractFactory("StandardTokenFactory");
    const factory = await Factory.deploy(await factoryManger.getAddress(), await standardToken.getAddress(), owner.address);

    return { factoryManger, factory};
  }

  describe("Deployment", function () {
    it("deploy", async function () {
      const { factoryManger, factory } = await loadFixture(deployFixture);
      console.log(await factoryManger.getAddress(), await factory.getAddress())
    });
  });
});
