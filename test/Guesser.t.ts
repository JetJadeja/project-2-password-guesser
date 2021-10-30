import { expect } from "chai";
import { ethers } from "hardhat";

import { Contract } from "@ethersproject/contracts";
import fs from "fs";

let guesser: Contract;

describe("Guesser", function () {
  beforeEach(async () => {
    const Guesser = await ethers.getContractFactory("Guesser");
    guesser = await Guesser.deploy();
  });

  describe("Common Passwords", async () => {
    let common: Contract;

    const passwords = fs
      .readFileSync("./test/utils/CommonPasswords.txt", "utf-8")
      .split("\n");

    it("Should deploy a password list'", async () => {
      let bytecode = "0x";
      for (let i = 0; i < passwords.length; i++) {
        bytecode += stringToBytes32(passwords[i]);
      }

      const Common = await ethers.getContractFactory("Common");
      common = await Common.deploy();

      await common.setPasswordList(bytecode, 50);
    });

    it("Should guess the password, returning the necessary data", async () => {
      expect(
        (await common.guess(`0x${stringToBytes32(passwords[49])}`))[0]
      ).to.equal(true);
    });
  });
});

function encodeArgs(types: string[], values: any[]): string {
  const abiCoder = new ethers.utils.AbiCoder();

  return abiCoder.encode(types, values).replace(/^(0x)/, "");
}

function stringToBytes32(text: string) {
  let bytes = ethers.utils.hexlify(ethers.utils.toUtf8Bytes(text));
  while (bytes.length < 66) {
    bytes += "0";
  }

  return bytes.substring(2);
}
