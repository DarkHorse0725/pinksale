import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";


const TokenModule = buildModule("Token", m => {
  const owner = "0xB2F37796Fff3Eab6aC8c1146b034520E519Ee1bF";
  const testToken = m.contract("Token", [owner, 'Test Token', 'TST']);
  // const fakeUSDT = m.contract("Token", [owner, 'fake usdt', 'USDT']);
  return {testToken}
})

export default TokenModule;

// Token#Token - 0xd973402f2329419C9dD8c1bF30598C33fD034115

