//SPDX-License-Identifier : UNLICENSED

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";


contract DVote{

   using Counters for Counters.Counter;

   Counters.Counter public voterId;
   Counters.Counter public candidateId ;
   
   address public votingOrganiser;

   //struct -> candidate for voting 

   struct Candidate{
    uint256 id;
    uint256 age;
    string name;
    string image;
    uint256 voteCount;
    address _address;
    string ipfs;
   }


   event  CandidateCreate(
    uint256 indexed  id,
    uint age,
    string name,
    string image,
    uint256 voteCount,
    address _address,
    string ipfs
   );

    address[] public candidateAddress;

    mapping(address => Candidate) public candidates;
    //---------  End for Candidate -----------


    // voter data

    address[] public votedVoters;
    address[] public votersAddress;
    mapping(address => Voter) public voters;

    struct Voter{
        uint voterID;
        string voterName;
        string voterImage;
        address voterAddress;
        uint voterAllowed;
        bool givenVote;
        uint voterVote;
        string ipfs;

    }


    event VoterCreated (
         uint indexed voterID,
        string voterName,
        string voterImage,
        address voterAddress,
        uint voterAllowed,
        bool givenVote,
        uint voterVote,
        string ipfs
    );

    // end of voter data


    constructor(){
        votingOrganiser = msg.sender;

    }

    function setCandidate(address address_ , uint age_,string memory name_ , string memory image_,string memory _ipfs) public {
            require(votingOrganiser == msg.sender, "Only Organizer Can Create Create a Candidate");

            candidateId.increment();

            uint idNumber = candidateId.current();

            Candidate storage candidate = candidates[address_];

            candidate.age = age_;                     
            candidate.name = name_;
            candidate.image = image_;
            candidate.ipfs = _ipfs;
            candidate._address = address_;
            candidate.id = idNumber;

            candidateAddress.push(address_);

            emit CandidateCreate(
                idNumber,
                age_,
                name_,
                image_,
                candidate.voteCount,
                address_,
                _ipfs
            );


    }

    function getCandidate() public view returns(address[] memory ){
        return candidateAddress;
    }

    function getCandidateLength() public view returns(uint256){
        return candidateAddress.length;
    }

    function getCandidateData(address address_) public view returns(uint , uint , string memory, string memory,uint , address , string memory ){
        return(
            candidates[address_].id,
            candidates[address_].age,
            candidates[address_].name,
            candidates[address_].image,
            candidates[address_].voteCount,
            candidates[address_]._address,
            candidates[address_].ipfs

        );



    }   

    function voterRight(address address_ ,string memory name_, string memory image_ , string memory ipfs_) public {

        require(votingOrganiser == msg.sender, "Only Organizer can create Voter");

        voterId.increment();
        uint idNumber = voterId.current();

        Voter storage voter = voters[address_];

        require(voter.voterAllowed == 0 , "Can vote fuck you");

        voter.voterAllowed == 1 ;
        voter.voterName = name_;
        voter.voterAddress = address_;
        voter.ipfs = ipfs_;
        voter.voterImage =image_;
        voter.voterID = idNumber;
        voter.voterVote = 100;
        voter.givenVote = false;


        votersAddress.push(address_);

        emit VoterCreated(idNumber,name_,image_,address_,voter.voterAllowed,voter.givenVote,voter.voterVote,ipfs_);



    }
    
    function vote(address _candidate , uint _candidateId)external {
        Voter storage voter = voters[msg.sender];

        require(!voter.givenVote, "You have already voted");
        require(voter.voterAllowed != 0 , "you have no right to vote");

        voter.givenVote = true;
        voter.voterVote = _candidateId;

        votedVoters.push(msg.sender);
        candidates[_candidate].voteCount += voter.voterAllowed;






    }   

    function getVoterLength() public view returns(uint){
        return votersAddress.length;
    }

    function getVoterdata(address address_) public view returns(uint  , string memory, string memory, address , uint , bool , string memory){
        return(
            voters[address_].voterID,
            voters[address_].voterName,
            voters[address_].voterImage,
            voters[address_].voterAddress,
            voters[address_].voterAllowed,
            voters[address_].givenVote,
            // voters[address_].voterVote,
            voters[address_].ipfs
                    
        );
    }

    function getVotedVoterList() public view returns(address[] memory){
        return votedVoters;
    }

     function getVoterList() public view returns(address[] memory){
        return votersAddress;
    }








}