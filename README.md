# Project

This project is a Password Guesser built for Austin Totty's CompSci class. It takes a user inputted password and will attempt to crack it with an algorithm selected by the user. The current algorithms include brute-force, dictionary (common password) attack, and a psuedo-random guesser that guesses each character instead of iterating through all potential passwords.

## Problem Solving

The catalyst for many of our design decisions was our decision to build this project in Solidity, a language built for the Ethereum Virtual Machine, a virtual machine used by the popular decentalrized smart contract platform known as Ethereum. Solidity was most entirely unsuitable for the given task, forcing us to use unique problem-solving methods (described below) in order to perservere. Many of these creative solutions required us to dig deep into the EVM, working with byte-level manipulation operations.

## Ethics

This password guesser was built for use in a controlled testing environment, which is the only way it should be used.

# Algorithms

As stated below, we use three different algorithms: brute force attack, dictionary attack, and a random guesser. Here is an explanation of each one and a description of the various implementation decisions we made during their development.

## Dictionary Attack

While this may be the easiest algorithm to write in most other langauges and environments, in Solidity this was the most difficult algorithm to develop. We ran into a wide variety of issues, but the main one was that there was simply no way to store the password list.

In the EVM, you're only able to access data if it is stored on-chain (somewhere within the EVM's storage). Until very recently, there's only been a single way of doing this: deploying a smart contract and storing data within it. This is the Java/JVM equivalent of instantiating a class and setting one of its variables.

The problem with this, however, is that it's very inefficient to both write data to and read data from contract storage, so we decided that we had to find a new strategy to store and read data. The issue with this, is that Ethereum wasn't built to read and store large portions of data, so there are few projects (if any) that use creative strategies to get around this.

Yet, we still were able to come up with an idea that is practically genius. In the EVM, smart contracts are pieces of EVM bytecode that can be interacted with, once deployed. As stated above, deploying a smart contract to the Ethereum platform is similar to instantiating a new class in the JVM.

Smart contracts, though, are solely used to hold executable bytecode that users can interact with. For example, the algorithms that are used for this project are all smart contracts that, while written in Solidity, are compiled to bytecode and deployed to a local testnet when they need to be used. However, the bytecode doesn't actually have to be *bytecode*; you're simply able to deploy a raw array of bytes without issue!

After realizing that we could take advantage of this, to decided to implement it! While we ran into so many issues, we eventually were able to get it to work; and this is how:

First, our list of common passwords is converted to bytes. However, in order for our contract to sucessfully iterate through the passwords on-chain, the size of each password needs to be known. This is impossible for the smart contract to know, so we decided to make each password a left-padded 32 byte array, so that the smart contract only needed to iterate over 32 bytes at a time for each password. Next, this large byte array is deployed to the network and its unique address is stored within our algorithm contract (so that it can be accessed later).

Whenever a user tries to guess a password, the common-password algorithm reads the data via `EXTCODECOPY` (an EVM opcode known as External Code Copy, which allows it to read code from other smart contracts), iterates through each 32 byte password, attempting to crack the user inputted password.

Overall, this was extremely difficult to implement, taking us much longer than it would have if we had used a language like Python or Java. However, we learned so much about so many things through the process of building this and it was a great experience.

## BruteForce

A Brute Force algorithm is also extremely difficult to implement because Solidity doesn't have the same high-level abstraction that other languages do when it comes to strings. Our algorithm used raw byte arrays rather than strings. Our creative solution for this problem was to iterate over all potential characters using an 8-bit unsigned integer that would be converted to a single byte representing a character. This process allowed us to efficiently guess the password by finding one character at a time, before moving to the next.

## Random

Finally, the random algorithm was difficult to implement because Solidity has no built-in (or even external) random library. The "go-to" for randomness in other languages is to use a value from the timestamp, however, since Solidity uses the timestamp of the current Ethereum block, which maintains the same value throughout the entirety of the contract execution we had to use something else. We decided to use `gasleft()` which is a pseudo-random, changing value.

# Installation and Setup

To install the necessary dependencies, you can use `npm i`. This project mainly uses a framework known as Hardhat for tests and also to automatically setup our runtime environment.

## Testing

`npx hardhat test`

## Running the program

`npx hardhat run scripts/deploy.ts`
