const hre = require("hardhat");

async function main() {
  const LandRegistry = await hre.ethers.getContractFactory("LandRegistry");
  const landRegistry = await LandRegistry.deploy();
  await landRegistry.waitForDeployment();

  const address = await landRegistry.getAddress();
  console.log("LandRegistry deployed to:", address);
  console.log("\nCopy this address into frontend/index.html (CONTRACT_ADDRESS) before opening it in a browser.");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
