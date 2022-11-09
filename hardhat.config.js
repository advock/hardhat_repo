require("@nomicfoundation/hardhat-toolbox");

const ALCHEMY_API_KEY = "kH74ovyVPFoFpi-ddofXYKhlVow_uy_S";

const GOERLI_PRIVATE_KEY = "7d39503c40b2a4490044ff4730381592c953a6560d23b3c39e507f29ed81304f";

/**
 * @type import('hardhat/config').HardhatUserConfig 
 */
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

module.exports = {
  solidity: "0.8.9",
  networks: {
    goerli: {
      url: `https://eth-goerli.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
      accounts: [`0x${GOERLI_PRIVATE_KEY}`],

    }
  }
};


