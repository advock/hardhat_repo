// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
const { TASK_COMPILE_SOLIDITY } = require("hardhat/builtin-tasks/task-names");

async function main() {
  //const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  // const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
  //const unlockTime = currentTimestampInSeconds + ONE_YEAR_IN_SECS;

  //const lockedAmount = hre.ethers.utils.parseEther("1");

  const Factory = await hre.ethers.getContractFactory("Factory");
  const factory = await Factory.deploy();

  await factory.deployed();
  console.log("factory address is ", factory.address)

  const Uniswap = await hre.ethers.getContractFactory("Uniswap");
  const uniswap = await Uniswap.deploy(factory.address);

  await uniswap.deployed();
  console.log("uniswap address is ", uniswap.address)

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
