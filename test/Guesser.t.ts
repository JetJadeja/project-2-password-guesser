import { expect } from "chai";
import { ethers } from "hardhat";

import { Contract } from "@ethersproject/contracts";

let guesser: Contract;

describe("Guesser", function () {
  beforeEach(async () => {
    const Guesser = await ethers.getContractFactory("Guesser");
    guesser = await Guesser.deploy();
  });

  it("", async () => {
    guesser;
  });
});
