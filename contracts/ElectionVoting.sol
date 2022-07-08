// SPDX-License-Identifier: MIT
pragma solidity ^ 0.8 .0;

/// @title Voting smart contract
contract ElectionVoting {

  // Model a Candidate 
  // @param Candidate id
  // @param Candidate name
  // @param voteCount
  // @param Address
  struct Candidate {
    uint id;
    string name;
    uint voteCount;
    address submitter;
  }

  // Model a Voter
  struct Voter {
    bool voted;
    uint vote;
  }

  // A dynamically-sized array of 'Content' structs.
  // Voter[] public voters;

  mapping(uint=>address[]) public voters;
  address submited;
 
  // Store Candidates
  // Fetch Candidate
  mapping(uint => Candidate) public candidates;

  mapping(uint => address[]) private tokentrack;
  // Store Candidates Count
  uint public candidatesCount;

  // voted event
   event votedEvent(
    string mine,uint indexed_candidateId
    );
   
  enum State {
    Created,
    Voting,
    Ended
  }
  State public state;

  event listAddress(address[]);

  modifier inState(State _state) {
    require(state == _state);
    _;
  }

  function Election() public {
    addCandidate("Donald Trump");
    addCandidate("Joe Biden");
  }

  //Function to add candidate 
  function addCandidate(string memory _name) private {
    candidatesCount++;
    candidates[candidatesCount] = Candidate(candidatesCount, _name, 0, submited);
    state = State.Created;
  }

  // Start Voting Phase
  function startVote() public inState(State.Created) {
    state = State.Voting;
  }

  // Do the voting
  function vote(uint _candidateId) public inState(State.Voting) {

    if (candidates[_candidateId].submitter == msg.sender) {
      require(candidates[_candidateId].submitter != msg.sender, "Already voted.");
    }   

    // require a valid candidate
    require(_candidateId > 0 && _candidateId <= candidatesCount);
    voters[_candidateId].push(msg.sender);
    candidates[_candidateId].voteCount++;
    tokentrack[_candidateId].push(msg.sender);
 
    candidates[_candidateId].submitter = msg.sender;
    emit votedEvent("election vote goes to",_candidateId);
  }

  // End Vote
  function endVote() public inState(State.Voting) {
    state = State.Ended;
  }

  function ListAllAddress(uint id) public view returns(address[] memory){
        return tokentrack[id];
  }
  
}