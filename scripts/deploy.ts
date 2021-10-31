// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from "hardhat";
import fs from "fs";

const passwords = fs
  .readFileSync("./scripts/utils/CommonPasswords.txt", "utf-8")
  .split("\n");

async function main(input: string, algo: string, password: string) {
  if (algo === "Common") {
    let bytecode = "0x";
    for (let i = 0; i < passwords.length; i++) {
      bytecode += stringToBytes32(passwords[i]);
    }

    const Common = await ethers.getContractFactory("Common");
    const common = await Common.deploy();

    await common.setPasswordList(bytecode, 700);
    await common.guess(password);
  } else if (algo === "BruteForce") {
    const BruteForce = await ethers.getContractFactory("BruteForce");
    const bruteForce = await BruteForce.deploy();

    bruteForce.guess(password);
  } else if (algo === "Random") {
    const Random = await ethers.getContractFactory("Random");
    const random = await Random.deploy();

    await random.guess(stringToBytes(password));
  }
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main("hi", "Common", "test").catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

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
