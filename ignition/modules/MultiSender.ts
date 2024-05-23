import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";


const MultiSenderModule = buildModule("MultiSender", m => {
  const sender = m.contract("MultiSender", []);
  return {sender}
});

export default MultiSenderModule;