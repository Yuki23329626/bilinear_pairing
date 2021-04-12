module.exports = {
  networks: {
    local: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*",
      gas: 0xffffffffffffffffffffff,
    },
    coverage: {
      host: "localhost",
      network_id: "*",
      port: 8555,
      gas: 0xffffffffffffffffffffff,
      gasPrice: 0x01,
    },
  },
  mocha: {
    reporter: "eth-gas-reporter",
    reporterOptions: {
      currency: "USD",
      gasPrice: 20,
      excludeContracts: ["Migrations"],
      src: "benchmark",
    },
  },
  compilers: {
    solc: {
      version: "0.6.8",    // Fetch exact version from solc-bin (default: truffle's version)
      settings: {
        optimizer: {
          enabled: true,
          runs: 200,
        },
      },
    },
  },
}
