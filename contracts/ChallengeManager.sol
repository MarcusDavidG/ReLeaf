// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./DigitalTwin.sol";

/**
 * @title ChallengeManager
 * @dev Manages eco-challenges, allowing creation, participation, and completion with NFT minting/updates and B3TR rewards.
 */
contract ChallengeManager is Ownable, AccessControl {
    bytes32 public constant COMPLETER_ROLE = keccak256("COMPLETER_ROLE");

    struct Challenge {
        uint256 id;
        string description;
        uint256 rewardAmount;
        uint256 nftRequired; // 0 if no specific NFT required
    }

    mapping(uint256 => Challenge) public challenges;
    uint256 public nextChallengeId;

    DigitalTwin public digitalTwin;
    ERC20 public b3tr;

    event ChallengeCreated(uint256 indexed challengeId, string description, uint256 rewardAmount, uint256 nftRequired);
    event ChallengeCompleted(uint256 indexed challengeId, address indexed user, uint256 tokenId);

    constructor(address _digitalTwin, address _b3tr) Ownable(msg.sender) {
        digitalTwin = DigitalTwin(_digitalTwin);
        b3tr = ERC20(_b3tr);
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(COMPLETER_ROLE, msg.sender); // Admin can complete for testing
        nextChallengeId = 1;
    }

    /**
     * @dev Creates a new challenge.
     * @param description The challenge description.
     * @param rewardAmount The B3TR reward amount.
     * @param nftRequired The required NFT tokenId (0 if none).
     */
    function createChallenge(string memory description, uint256 rewardAmount, uint256 nftRequired) external onlyOwner {
        uint256 challengeId = nextChallengeId++;
        challenges[challengeId] = Challenge({
            id: challengeId,
            description: description,
            rewardAmount: rewardAmount,
            nftRequired: nftRequired
        });
        emit ChallengeCreated(challengeId, description, rewardAmount, nftRequired);
    }

    /**
     * @dev Allows a user to participate in a challenge (checks requirements).
     * @param challengeId The ID of the challenge.
     */
    function participate(uint256 challengeId) external view {
        Challenge memory c = challenges[challengeId];
        require(c.id != 0, "Challenge does not exist");
        if (c.nftRequired != 0) {
            require(digitalTwin.ownerOf(c.nftRequired) == msg.sender, "User does not own required NFT");
        }
        // Participation is implicit; completion will verify again
    }

    /**
     * @dev Completes a challenge for a user, minting/updating NFT and rewarding B3TR.
     * @param challengeId The ID of the challenge.
     * @param user The user completing the challenge.
     * @param metadataURI The IPFS URI for new NFT metadata (if minting).
     */
    function completeChallenge(uint256 challengeId, address user, string memory metadataURI) external onlyRole(COMPLETER_ROLE) {
        Challenge memory c = challenges[challengeId];
        require(c.id != 0, "Challenge does not exist");

        uint256 tokenId;
        if (c.nftRequired == 0) {
            // Mint new NFT
            tokenId = digitalTwin.safeMint(user, metadataURI);
        } else {
            // Update existing NFT history and URI
            digitalTwin.logHistory(c.nftRequired, string(abi.encodePacked("Completed challenge: ", c.description)));
            digitalTwin.updateTokenURI(c.nftRequired, metadataURI);
            tokenId = c.nftRequired;
        }

        // Reward B3TR
        require(b3tr.balanceOf(address(this)) >= c.rewardAmount, "Insufficient B3TR balance");
        b3tr.transfer(user, c.rewardAmount);

        emit ChallengeCompleted(challengeId, user, tokenId);
    }

    /**
     * @dev Funds the contract with B3TR tokens for rewards.
     * @param amount The amount to fund.
     */
    function fundRewards(uint256 amount) external {
        b3tr.transferFrom(msg.sender, address(this), amount);
    }
}
