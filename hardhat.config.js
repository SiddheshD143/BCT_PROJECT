require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.19",
  networks: {
    // Default local network started with: npx hardhat node
    localhost: {
      url: "http://127.0.0.1:8545",
    },
  },
};
