# ReLeaf

ReLeaf is a gamified eco-challenge dApp built on VeChain for the Global Hackathon. It transforms recycling into an engaging experience through blockchain-powered digital twins, challenges, and rewards.

## Project Vision

ReLeaf combines gamification with sustainability by allowing users to participate in eco-challenges. Completing challenges mints or updates DigitalTwin NFTs representing recycled products and rewards users with B3TR tokens, promoting a circular economy on VeChain.

## Smart Contract Structure

- **B3TR.sol**: ERC20 token for rewards ("Best 3arth Token").
- **DigitalTwin.sol**: ERC721 NFT for product digital twins with lifecycle tracking.
- **ChallengeManager.sol**: Manages eco-challenges, participation, and completion with rewards.

## Setup Instructions

### Prerequisites
- Node.js
- Hardhat
- VeChain wallet (VeWorld)

### Install Dependencies
```bash
npm install
```

### Deploy Contracts
```bash
npx hardhat ignition deploy ignition/modules/DigitalScript.ts --network vechain_testnet
```

### Run Frontend
```bash
cd frontend
npm install
npm run dev
```

## Hackathon Alignment

ReLeaf aligns with VeChain's sustainability focus and x-to-earn models by incentivizing real-world recycling actions through blockchain rewards and NFTs.

Deployed Contracts (Testnet):
- B3TR: 0x9ca37e813baf1cad2eb1269661d1536b1afa9dde
- DigitalTwin: 0x871879bc4030aab14fb00912c83e105f92fb8167
