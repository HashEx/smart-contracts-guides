const hre = require("hardhat");

async function main() {
    const ClaimOwnership = await hre.ethers.getContractFactory("ClaimOwnership");

    console.log("Deploying ClaimOwnership...");
    const claimOwnershipInst = await ClaimOwnership.deploy();
    await claimOwnershipInst.deployed();

    console.log("Initializing ClaimOwnership...");
    await claimOwnershipInst.init();

    console.log("ClaimOwnership deployed to:", claimOwnershipInst.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
