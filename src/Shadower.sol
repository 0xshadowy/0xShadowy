// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "solmate/tokens/ERC721.sol";
import "solmate/auth/Owned.sol";
import "./Repository.sol";

contract Shadower is ERC721, Owned {
    uint256 public totalShadowers;
    uint256 public totalContributions;

    Repository private _repository;

    enum ContributionType { PULL_REQUEST_OPENED, PULL_REQUEST_MERGED, ISSUE_OPENED }

    struct Shad {
        uint256 id;
        uint256 totalRepositoriesContributed;
        uint256 totalPullRequestsOpened;
        uint256 totalPullRequestsMerged;
        uint256 totalIssuesOpened;
        address addr;
        string username;
        string handle;
    }

    struct Contribution {
        uint256 id; // PR/Issue Id
        address contributor;
        string repoUrl;
        ContributionType contributionType;
    }

    mapping(address => Shad) public shadowers;
    mapping(address => mapping(string => bool)) public contributedTo;
    mapping(address => Contribution[]) public shadToContributions;

    event NewShad(uint256 indexed id, string indexed username, string indexed handle);
    event NewContribution(address indexed shad, string indexed url, ContributionType indexed contributionType);

    constructor(address repository) ERC721("Shadower", "SHAD") Owned(msg.sender) {
        _repository = Repository(repository);
    }

    function isAShad(address addr) public view returns (bool) {
        return shadowers[addr].addr != address(0);
    }

    function registerAShad(string memory username, string memory handle) public returns (uint256) {
        require(!isAShad(msg.sender), "Already a big Shad");
        uint256 newTotalShadowers = ++totalShadowers;

        _safeMint(msg.sender, newTotalShadowers);
        shadowers[msg.sender] = Shad(newTotalShadowers, 0, 0, 0, 0, msg.sender, username, handle);

        emit NewShad(newTotalShadowers, username, handle);

        return newTotalShadowers;
    }

    function registerContribution(string memory repoUrl, ContributionType contributionType, uint256 id) public {
        if (!isAShad(msg.sender)) revert();

        Shad storage shad = shadowers[msg.sender];

        if (contributionType == ContributionType.PULL_REQUEST_OPENED) shad.totalPullRequestsOpened++;
        if (contributionType == ContributionType.PULL_REQUEST_MERGED) shad.totalPullRequestsMerged++;
        if (contributionType == ContributionType.ISSUE_OPENED) shad.totalIssuesOpened++;

        if (!contributedTo[msg.sender][repoUrl]) {
            contributedTo[msg.sender][repoUrl] = true;
            shad.totalRepositoriesContributed++;
        }

        ++totalContributions;
        Contribution memory contribution = Contribution(id, msg.sender, repoUrl, contributionType);
        shadToContributions[msg.sender].push(contribution);

        emit NewContribution(msg.sender, repoUrl, contributionType);
    }

    function tokenURI(uint256 id) public view virtual override returns (string memory) {
        return "Hello";
    }
}
