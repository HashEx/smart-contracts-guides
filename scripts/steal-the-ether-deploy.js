const hre = require("hardhat");

async function main() {
    const StealTheEther = await hre.ethers.getContractFactory("StealTheEther");

    console.log("Deploying StealTheEther...");
    const stealTheEtherInst = await StealTheEther.deploy({
        value: hre.ethers.constants.WeiPerEther.mul(2),
    });
    await stealTheEtherInst.deployed();

    console.log("StealTheEther deployed to:", stealTheEtherInst.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
