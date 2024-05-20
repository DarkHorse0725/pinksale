import { ethers } from "hardhat";

async function main() {
  const factory = await ethers.getContractAt("PresaleFactory", "0x7F363B52BaFd2dbf343e293b2FA27A11D9De6ebb");
  await factory.adminAllowPresaleGenerator("0xb15738944Ed45E0655a50598bBF709a72F7F87fa", true);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// presale factory -  0x7F363B52BaFd2dbf343e293b2FA27A11D9De6ebb
// locker -  0x2d78fe1325F95aB63b8D5385C3C8DCC5FB623f0F
// locker forwarder -  0xD97EB6C6954F2A399e082aA15807F04888100b86
// presale generator -  0xb15738944Ed45E0655a50598bBF709a72F7F87fa