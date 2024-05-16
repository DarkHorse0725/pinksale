import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const PresaleMudule = buildModule("PresaleModule", (m) => {
  const swapFactory = "0x4B480914A1375C93668Aa1369d11B42a9dAdC8e9";
  // const swapRouter = "0xB26B2De65D07eBB5E54C7F6282424D3be670E1f0";
  const owner = "0xB2F37796Fff3Eab6aC8c1146b034520E519Ee1bF"
  const presaleFactory = m.contract("PresaleFactory", [owner]);
  const locker = m.contract("SmartLocker", [swapFactory, owner]);
  return {presaleFactory};
});

export default PresaleMudule;

