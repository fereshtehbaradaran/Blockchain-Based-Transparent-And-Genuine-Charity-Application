module.exports = {
  networks: {
    loc_development_development: {
      network_id: "*",
      port: 8545,
      host: "127.0.0.1"
    },
    loc_charitytest2_charitytest2: {
      network_id: "*",
      port: 8546,
      host: "127.0.0.1"
    }
  },
  mocha: {},
  compilers: {
    solc: {
      version: "0.8.17"
    }
  }
};
