require("@nomicfoundation/hardhat-toolbox");


require("dotenv").config({ path: ".env" });
const HTTP_URL = process.env.HTTP_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const POLYGONSCAN_KEY = process.env.LOYGONSCAN_KEY;

module.exports = {
  solidity: "0.8.9",
  networks: {
    munbai: {
      url: HTTP_URL,
      accounts: [PRIVATE_KEY],
    },
    polygon:{
      url:HTTP_URL,
      accounts:[PRIVATE_KEY],
    },
  
  },
  etherscan:{
    apiKey:POLYGONSCAN_KEY,
  }
};
