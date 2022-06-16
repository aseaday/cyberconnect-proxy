const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Greeter", function () {
  it("Should return the new greeting once it's changed", async function () {
    const Cc = await ethers.getContractFactory("CyberConnect");
    const cc = await Cc.deploy();
    await cc.deployed();
    console.log(await cc.getUrl("0x148d59faf10b52063071eddf4aaf63a395f2d41c", "CyberConnect"));
  });
});
