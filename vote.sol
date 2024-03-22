pragma solidity = 0.8.12;

contract simpleVote {

    address private owner;

    constructor() {
        owner = msg.sender; 
    }

    struct Candidate {
        uint id;
        string name;
        address account;
        uint vote;
        address[] votants;
    }

    struct Votant {
        bool isVote;
    }

    mapping(uint => Candidate) candidates;
    uint public candidatesLength = 0;
    mapping(address => Votant) votants;
    uint public votantLength = 0;

    modifier onlyOwner() {
        require(msg.sender == owner, "Seul le proprietaire peut appeler cette fonction.");
        _;
    }

    function registerCandidate(string memory name,address account) public onlyOwner {

        for (uint i = 1; i <= candidatesLength; i++) {
            require(candidates[i].account != account, "Un candidat avec cette adresse existe deja.");
        }
        
        address[] memory emptyArray;
        candidatesLength++;
        candidates[candidatesLength] = Candidate(candidatesLength,name,account,0,emptyArray);
        return;
    }

    function getCandidates() public view returns (Candidate[] memory) {
        Candidate[] memory allCandidates = new Candidate[](candidatesLength);
        for (uint i = 1; i <= candidatesLength; i++) {
            allCandidates[i - 1] = candidates[i];
        }
        return allCandidates;
    }

    function addVotant(address votant) public onlyOwner {
        votants[votant].isVote = false;
    }

    function vote(uint id) public {
        require(votants[msg.sender].isVote == false, "tu a deja vote");
        candidates[id].vote ++;
        candidates[id].votants.push(msg.sender);
        votants[msg.sender].isVote = true;
    }


}