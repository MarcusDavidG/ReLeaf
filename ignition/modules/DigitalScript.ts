// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const ReLeafModule = buildModule("ReLeafModule", (m) => {
  // Deploy B3TR token
  const b3tr = m.contract("B3TR", [m.getAccount(0)]);

  // Deploy DigitalTwin with B3TR address
  const digitalTwin = m.contract("DigitalTwin", [b3tr]);

  // Deploy ChallengeManager with DigitalTwin and B3TR addresses
  const challengeManager = m.contract("ChallengeManager", [digitalTwin, b3tr]);

  return { b3tr, digitalTwin, challengeManager };
});

export default ReLeafModule;
