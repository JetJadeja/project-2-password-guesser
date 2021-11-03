// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from "hardhat";
import fs from "fs";
import { getSystemErrorMap } from "util";
import { any } from "hardhat/internal/core/params/argumentTypes";

const passwords = fs
  .readFileSync("./scripts/utils/CommonPasswords.txt", "utf-8")
  .split("\n");
var chosen = '';
var chosenPass = '';
  var term = require( 'terminal-kit' ).terminal ;


//option to start each algo
//option to learn more about Time complexity
  term.table( [
      [ 'ALGORITHIM', 'Big-O Time' , 'description'] ,
      [ 'Common Password', 'Best: O(1)\nAverage: O(n)\nWorst: Fails' , "The Common Password attack runs through a list of common passwords and tests them against the inputted password."] ,
      [ 'Brute Force' , 'Best: O(1)\nAverage: O(n)\nWorst: O(128\^n)', 'The Brute Force attack runs through all possible passwords and tests them against the inputted password.'] ,
      [ 'Random' , 'Best: O(1)\nAverage:O(1 / 128\^n)\nWorst: O(∞)', 'Random generates a random password hash using the current gas as a seed.']
    ] , {
      hasBorder: true ,
      contentHasMarkup: true ,
      borderChars: 'lightRounded' ,
      borderAttr: { color: 'blue' } ,
      textAttr: { bgColor: 'default' } ,
      firstCellTextAttr: { bgColor: 'blue' } ,
      firstRowTextAttr: { bgColor: 'blue' } ,
      firstColumnTextAttr: { bgColor: 'red' } ,
      width: 80 ,
      fit: true   // Activate all expand/shrink + wordWrap
    }
  ) ;
var items = [
	'a. Test Algorithim' ,
	'b. Learn More About An Algorithim'
] ;
var options = {	// the menu will be on the top of the terminal
  style: term.inverse ,
  continue: true,
  selectedStyle: term.dim.blue.bgGreen
  } ;
  var algos = [ 'Common Password' , 'Brute Force' , 'Random'];
term.singleColumnMenu( items , function( error: any , response: any ) {
  console.log(response.selectedIndex);
  if(response.selectedIndex == 0){
    term.singleLineMenu( algos , options , function( error: any , responsea: any ) {
      if(responsea.selectedIndex == 0){ //Common
        chosen = "Common"
      }else if(responsea.selectedIndex == 0){
        chosen = "BruteForce"
      }else if(responsea.selectedIndex == 0){
        chosen = "Random"
      }
      term("\nPassword to test will be:\n");
      term('\n').inputField(async function(error: any, input: any){
        chosenPass = input;
        await main("hi", chosen, chosenPass).catch((error) => {
          console.error(error);
          process.exitCode = 1;

        }
        );
        //process.exit();
      });
    });
   
  }
  if(response.selectedIndex == 1){
    term.singleLineMenu( algos , options , function( error: any , responsea: any ) {
      if(responsea.selectedIndex == 0){ //Common
      term( '\n' ).eraseLineAfter.white(
      'Explanations of Time Complexity:\n^GBest: \nO(1) because the first pass it tries could be correct pass.',
       '\n^RWorst: \n None, the password could very well just not be one of the ones in the list and then the list would fail.',
        "\n^WAverage: \nO(n) assuming that the list contains the password used, otherwise none.\n"
      );
      }
      if(responsea.selectedIndex == 1){ //Brute
        term( '\n' ).eraseLineAfter.white(
          'Explanations of Time Complexity:\n^GBest: \nO(1) because the password could be 0x0.\n',
           ' ^RWorst: \nO(128\^n) because there are 128 ASCII characters and thus for every character in the password string we exponentially increase the amount of time needed to guess the correct string hash.\n',
            ' ^WAverage: \nO(128\^n) because the time to find an answer increases exponentially as the task size increases.'
          );
        }
        if(responsea.selectedIndex == 2){ //Random
          term( '\n' ).eraseLineAfter.white(
            'Explanations of Time Complexity:\n^GBest: \nO(1) though unlikely, the first password that this guesses could be the correct password.\n',
             ' ^RWorst: \nO(128\^n) because there are 128 characters in ascii and the proability of getting a correct answer decreases as the string gets longer.\n',
              '^WAverage: \nO(1 / 128\^n): Chance of getting the hash correct on any one run.\n'
            );
          }
      process.exit();
    } ) ;
  }
	
} ) ;

async function main(input: string, algo: string, password: string) {
  if (algo === "Common") {
    let bytecode = "0x";
    for (let i = 0; i < passwords.length; i++) {
      bytecode += stringToBytes32(passwords[i]);
    }

    const Common = await ethers.getContractFactory("Common");
    const common = await Common.deploy();

    await common.setPasswordList(bytecode, 700);
    var o1, o2 = await common.guess(stringToBytes(password));
    term("Guessed Password Correctly: ", o1, "\nNumber of Tries: ", o2)
    term("\nYou could try to diversify your password with special symbols, e.g. 'maverick' becomes 'mav3r1ck")

  } else if (algo === "BruteForce") {
    const BruteForce = await ethers.getContractFactory("BruteForce");
    const bruteForce = await BruteForce.deploy();
    var o1, o2 = await bruteForce.guess(stringToBytes(password));
    term("Guessed Password Correctly: ", o1, "\nNumber of Tries: ", o2)
    term("\n An increase in the length of this password would significantly increase its difficultly, considering adding more characters to it.")
  } else if (algo === "Random") {
    const Random = await ethers.getContractFactory("Random");
    const random = await Random.deploy();
    var o1, o2 = await random.guess(stringToBytes(password));
    term("Guessed Password Correctly: ", o1, "\nNumber of Tries: ", o2)
    term("\nIf this message is deployed then that means that the random pass generator guessed it correctly,\n you should feel lucky to even exist in the same 1000 years as an instance of this occurring.")

  }
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main("hi", chosen, chosenPass).catch((error) => {
  
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
