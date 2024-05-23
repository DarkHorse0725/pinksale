import { ethers, upgrades} from "hardhat";

async function main () {
  const [owner, ...others] = await ethers.getSigners();
  // const FactoryManager = await ethers.getContractFactory("TokenFactoryManager");
  // const factoryManager = await FactoryManager.deploy(owner.address);

  // console.log('factory manager -', await factoryManager.getAddress());

  // const StandardToken = await ethers.getContractFactory("StandardToken");
  // const standardToken = await StandardToken.deploy(
  //   "Test token",
  //   "TST",
  //   18,
  //   ethers.parseEther("1"),
  //   owner.address,
  //   ethers.parseEther("0.001"),
  //   {value: ethers.parseEther("0.001")}
  // );
  const Factory = await ethers.getContractFactory("StandardTokenFactory");
  const factory = await Factory.deploy(
    "0x5bAB4FcE73CE959dae4d6cCf500BeD6A2DD33891",
    "0xe2a8a54c198627F1d67df5f888b5Ed4122b191B4",
    owner.address
  );
  console.log('factory -', await factory.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// factory manager - 0x5bAB4FcE73CE959dae4d6cCf500BeD6A2DD33891