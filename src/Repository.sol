// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "solmate/tokens/ERC721.sol";
import "solmate/auth/Owned.sol";

contract Repository is ERC721, Owned {
    uint256 public totalRepositories;

    struct Repo {
        uint256 id;
		uint256 totalContributors;
        address owner;
        string url;
    }

    mapping(uint256 => Repo) public repositories;
	mapping(string => bool) public registeredRepositories;

    event NewRepo(uint256 indexed id, address indexed owner, string indexed url);

    constructor() ERC721("Repository", "REPO") Owned(msg.sender) {}

	function isRegistered(string memory url) public view returns (bool) {
		return registeredRepositories[url];
	}

    function register(string memory url) public returns (uint256) {
        require(!isRegistered(url), "Already registered");

        uint256 newTotalRepositories = ++totalRepositories;

        _safeMint(msg.sender, newTotalRepositories);

		registeredRepositories[url] = true;
        repositories[newTotalRepositories] = Repo(newTotalRepositories, 0, msg.sender, url);

        emit NewRepo(newTotalRepositories, msg.sender, url);

		return newTotalRepositories;
    }

    function tokenURI(uint256 id) public view virtual override returns (string memory) {
        return "Hello";
    }
}
