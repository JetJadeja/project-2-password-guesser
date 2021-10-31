##Project
The application is a password guesser. It takes a user's inputted password and will attempt to break it with one of three algorithms, brute-force, dictonary attack(dictonary comprised of most common passwords), and an alternative form of the brute-force attack which uses remaining gas to guess random passwords rather than iterating through all possible passwords.
##Problem Solving
The catalyst for a lot of our design decisions was our decision to make the password guesser in Solidity, a language that is most entirely unsuitible for the task given to us. The exemplar of this is the common password guesser, whose creation was limited by the 24KB gas limit for smart contracts on the EVM, to overcome this we had to dig into the guts of Solidity and Assembly by storing the password list as bytecode in a created smart contract and then reading that smart contract as string hashes.


##Ethics
This password breaker was built for use in a controlled testing environment which is the only way that it should be used. 