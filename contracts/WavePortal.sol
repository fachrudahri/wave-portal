// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;

    // set seed
    uint256 private seed;

    // litle magic from solidity, google it!
    event NewWave(address indexed from, uint256 timestamp, string message);

    // create new struct with name wave
    struct Wave {
        address waver; // the adress of the user who waved.
        string message; // the message the user sent.
        uint256 timestamp; // the timestamp when the user waved.
    }

    // after declare a variable waves that lest store an array of structs.
    // this is whats lets told all the waves anyone ever sends to me
    Wave[] waves;

    // added mapping meaning I can associate an address with a number! 
    // In this case, I'll be storing the address with the last time the user waved at us.
    mapping(address => uint256) public lastWavedAt;

    constructor() payable {
        console.log("We have been constructed");

        // set the initial seed
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public {
        // to makesure the current timestamp is at least 15 minutes bigget than
        // the last timestamp we stored
        require(
            lastWavedAt[msg.sender] + 30 seconds < block.timestamp,
            "Must Wait 30 seconds before waving again"
        );

        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        console.log("%s wave w/ message %s!", msg.sender, _message);

        // this is where i actually store the wave data in the array.
        waves.push(Wave(msg.sender, _message, block.timestamp));

        // generate a new seed for the next user that sends a wave
        seed = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated %d", seed);

        if(seed < 50) {
            console.log("%s won!", msg.sender);
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(
                success,
                "Failed to withdraw money from contract.");
        }

        // Added some fanciness here, google it and try to figure out
        emit NewWave(msg.sender, block.timestamp, _message);

    }

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }
}