import { ethers } from "hardhat";

async function main() {
  const [owner, ...others] = await ethers.getSigners();
  const swapFactory = "0x4B480914A1375C93668Aa1369d11B42a9dAdC8e9";
  const swapRouter = "0xB26B2De65D07eBB5E54C7F6282424D3be670E1f0";
  const PresaleFactory = await ethers.getContractFactory("PresaleFactory");
  const presaleFactory = await PresaleFactory.deploy(owner.address);
  console.log("presale factory - ", await presaleFactory.getAddress());
  const Locker = await ethers.getContractFactory("SmartLocker");
  const locker = await Locker.deploy(swapFactory, owner.address);
  console.log('locker - ', await locker.getAddress());
  const LockerForwarder = await ethers.getContractFactory("SmartLockForwarder");
  const lockerForwarder = await LockerForwarder.deploy(
    await presaleFactory.getAddress(),
    await locker.getAddress(),
    swapFactory,
    owner.address
  );
  console.log('locker forwarder - ', await lockerForwarder.getAddress());
  // console.log(await lockerForwarder.presaleFactory())
  const PresaleGenerator = await ethers.getContractFactory("PresaleGenerator");
  const presaleGenerator = await PresaleGenerator.deploy(
    await presaleFactory.getAddress(),
    await lockerForwarder.getAddress(),
    owner.address,
    owner.address
  );
  console.log('presale generator - ', await presaleGenerator.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// presale factory -  0x7F363B52BaFd2dbf343e293b2FA27A11D9De6ebb
// locker -  0x2d78fe1325F95aB63b8D5385C3C8DCC5FB623f0F
// locker forwarder -  0xD97EB6C6954F2A399e082aA15807F04888100b86
// presale generator -  0xb15738944Ed45E0655a50598bBF709a72F7F87fa