const { ethers } = require("hardhat");

async function main() {
  // Deploy the ConsentRegistry contract
  const consentRegistryContract = await ethers.getContractFactory("ConsentRegistry");
  const deployedConsentRegistryContract = await consentRegistryContract.deploy();

  // Wait for it to finish deploying
  await deployedConsentRegistryContract.deployed();

  // Print the address of the deployed contract
  console.log("ConsentRegistry Contract Address:", deployedConsentRegistryContract.address);
}

// Call the main function and catch if there is any error
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
