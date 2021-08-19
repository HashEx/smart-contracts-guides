const hre = require("hardhat");

async function main() {
    const ERC20Test = await hre.ethers.getContractFactory("ERC20Test");
    const Dex = await hre.ethers.getContractFactory("Dex");

    console.log("Deploying Token0...");
    const token0Inst = await ERC20Test.deploy(
        hre.ethers.constants.WeiPerEther
    );
    await token0Inst.deployed();
    console.log("Token0 deployed to:", token0Inst.address);
    console.log("Deploying Token1...");
    const token1Inst = await ERC20Test.deploy(
        hre.ethers.constants.WeiPerEther.mul(2)
    );
    await token1Inst.deployed();
    console.log("Token1 deployed to:", token1Inst.address);


    console.log("Deploying Dex...");
    const dexInst = await Dex.deploy(
        hre.ethers.constants.WeiPerEther.mul(2)
    );
    await dexInst.deployed();
    console.log("Dex deployed to:", dexInst.address);


    console.log("Transfering tokens to dex contract...");
    await token0Inst.transfer(dexInst.address, await token0Inst.totalSupply());
    await token1Inst.transfer(dexInst.address, await token1Inst.totalSupply());
    console.log("Tokens are transfered to dex contract");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
