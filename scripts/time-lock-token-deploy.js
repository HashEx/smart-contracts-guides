const hre = require("hardhat");

async function main() {
    const TimeLockToken = await hre.ethers.getContractFactory("TimeLockToken");

    console.log("Deploying TimeLockToken...");
    const timeLockTokenInst = await TimeLockToken.deploy(
        hre.ethers.constants.WeiPerEther
    );
    await timeLockTokenInst.deployed();

    console.log("TimeLockToken deployed to:", timeLockTokenInst.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
