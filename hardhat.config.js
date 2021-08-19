require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
let secrets = require("./secrets.js");

module.exports = {
    networks: {
        hardhat: {},
        rinkeby: {
            url: "https://rinkeby.infura.io/v3/" + secrets.infuraIdProject,
            accounts: secrets.testnetAccounts,
        },
        ropsten: {
            url: "https://ropsten.infura.io/v3/" + secrets.infuraIdProject,
            accounts: secrets.testnetAccounts,
        },
        kovan: {
            url: "https://kovan.infura.io/v3/" + secrets.infuraIdProject,
            accounts: secrets.testnetAccounts,
        },
        bscTestnet: {
            url: "https://data-seed-prebsc-1-s1.binance.org:8545",
            accounts: secrets.testnetAccounts,
        },
    },
    etherscan: {
        apiKey: secrets.apiKey,
    },
    solidity: {
        version: "0.8.4",
        settings: {
            optimizer: {
                enabled: true,
                runs: 999999,
            },
        },
    },
};
