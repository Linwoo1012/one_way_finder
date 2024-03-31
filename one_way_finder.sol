// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract OneWayFinder {
    bytes32 public digest;
    address owner;
    string public salt;
    bool public isShow = false;
    mapping(address => bytes32) hashNum;
    mapping(address => bool) isPlayed;
    mapping(address => bool) isReward;

    constructor() {
        owner = msg.sender;
    }

    function setSalt(string memory _salt) public {
        require(msg.sender == owner, "Only owner can set salt");
        salt = _salt;
    }

    function getSaltedHash(string memory data, string memory _salt) public pure returns(bytes32){
        return keccak256(abi.encodePacked(data, _salt));
    }

    function sharedAnswer(bytes32 hash) public payable {
        require(!isShow, "Already show true answer");
        require(msg.sender == owner, "Only owner can show true answer");
        require(msg.value == 5 ether, "You need to pay 5 ether");
        digest = hash;
        isShow = true;
    }

    function checkAnswer(string memory answer, string memory _salt) public payable {
        require(getSaltedHash(answer, _salt) == digest, "Wrong answer");
        require(!isPlayed[msg.sender], "You already played");
        // payable(msg.sender).transfer(5 ether);
        isPlayed[msg.sender] = true;
    }

    function claimReward() public payable {
        require(isPlayed[msg.sender], "You haven't played yet");
        require(!isReward[msg.sender], "You already claimed reward");
        payable(msg.sender).transfer(5 ether);
        isReward[msg.sender] = true;
    }
}
