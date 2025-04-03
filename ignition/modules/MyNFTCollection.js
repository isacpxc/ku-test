const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("MyNTFCollection", (m) => {
    const MyNTFCollection = m.contract("MyNFTCollection", ["0xb90F26F439129c1ea66b36Eb0C5f53ec8e55ECa4"]);

    return {MyNTFCollection};
});