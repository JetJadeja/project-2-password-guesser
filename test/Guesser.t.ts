import { expect } from "chai";
import { ethers } from "hardhat";

import { Contract } from "@ethersproject/contracts";
import fs from "fs";

let guesser: Contract;

describe("Guesser", function () {
  this.timeout(300000); // Set new timeout

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

      await common.setPasswordList(bytecode, 700);
    });

    it("Should guess the password, returning the necessary data", async () => {
      expect(
        (
          await common.guess(
            `0x${stringToBytes32(passwords[Math.floor(Math.random() * 700)])}`
          )
        )[0]
      ).to.equal(true);
    });
  });

  describe("Brute Force", async () => {
    it("Should guess the password", async () => {
      const BruteForce = await ethers.getContractFactory("BruteForce");
      const bruteForce = await BruteForce.deploy();

      expect((await bruteForce.guess(stringToBytes("iloveyou")))[0]).to.equal(
        true
      );
    });
  });

  describe("Random", async () => {
    it("Should guess the password", async () => {
      const Random = await ethers.getContractFactory("Random");
      const random = await Random.deploy();

      await random.guess(stringToBytes("i"));
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

function stringToBytes(text: string) {
  return ethers.utils.hexlify(ethers.utils.toUtf8Bytes(text));
}
