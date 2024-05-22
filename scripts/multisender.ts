import { ethers } from "hardhat";

async function main() {
  const Sender = await ethers.getContractFactory("MultiSender");
  const sender = await Sender.deploy();
  console.log('Multi sender - ', await sender.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// Multi sender -  0x1699a7a0dad0267495cA9272818b8E9D3667Ed54