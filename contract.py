import smartpy as sp

class Ballot(sp.Contract):
    def __init__(self, name, manager, candidates, voters, numberOfVotes):
        initialBallot = {}
        for candidate in candidates:
            # Initializing initialBallot where we save `candidateName` and set `numberOfVotes` to zero
            initialBallot[candidate[0]] = sp.record(candidateName = candidate[1], numberOfVotes = 0)
        initialVoters = { }
        for voter in voters:
            # For every voter set their remaining votes to maximum
            initialVoters[voter] = numberOfVotes
        self.init(name = name, manager = manager, ballot = initialBallot, voters = initialVoters, hasEnded = False, totalNumberOfVotes = 0, votesPerVoter = numberOfVotes)
        

    @sp.entry_point
    def vote(self, params):
        sp.verify(self.data.hasEnded == False)
        sp.verify(self.data.voters.contains(sp.sender))
        sp.for vote in params.votes.items():
            sp.verify(self.data.voters[sp.sender] >= vote.value)
            self.data.ballot[vote.key].numberOfVotes += vote.value
            self.data.voters[sp.sender] -= vote.value
            self.data.totalNumberOfVotes += vote.value
        
        
    @sp.entry_point
    def end(self, params):
        sp.verify(sp.sender == self.data.manager)
        sp.verify(self.data.hasEnded == False)
        sp.for candidate in self.data.ballot.keys():
            sp.if self.data.ballot[candidate].numberOfVotes != 0:
                sp.send(candidate, sp.split_tokens(sp.balance, sp.as_nat(self.data.ballot[candidate].numberOfVotes), sp.as_nat(self.data.totalNumberOfVotes)))
        self.data.hasEnded = True

        
@sp.add_test(name = "CandidatesTest")
def test1():
    scenario = sp.test_scenario()
    scenario.h1("Candidates")
    
    # Candidates
    addr1 = sp.address("tz1LhS2WFCinpwUTdUb991ocL2D9Uk6FJGJK")
    addr2 = sp.address("tz1a6SkBrxCywRHHsUKN3uQse7huiBNSGb5p")
    addr3 = sp.address("tz3WXYtyDUNL91qfiCJtVUX746QpNv5i5ve5")
    # Manager - can end the voting
    addr4 = sp.address("tz1SwKQDtW8H7xLAS9ag4nxXbsQP5Pejwr7z")
    # Voters
    addr5 = sp.address("tz1SwKQDtW8H7xLAS9ag4nxXbsQP5Pejwr7z")
    addr6 = sp.address("tz1YH2LE6p7Sj16vF6irfHX92QV45XAZYHnX")
    
    contract = Ballot("Design", addr4, [(addr1, "George"), (addr2, "Tim"), (addr3, "Gina")], [addr5, addr6], 2)
    contract.balance = sp.tez(9)
    
    scenario += contract
    
    # Votes succeed
    scenario += contract.vote(votes = {addr1: 2}).run(valid = True,sender = addr5)
    scenario += contract.vote(votes = {addr2: 1}).run(valid = True, sender = addr6)
    # Not enough votes - vote fails
    scenario += contract.vote(votes = {addr1: 1}).run(valid=False,sender = addr5)
    
    # Assert addr1 has 2 votes, addr2 has 1 vote
    scenario.verify(contract.data.ballot[addr1] == sp.record(candidateName = "George", numberOfVotes = 2))
    scenario.verify(contract.data.ballot[addr2] == sp.record(candidateName = "Tim", numberOfVotes = 1))    
    
    # Ending contract
    scenario += contract.end().run(valid = True, sender = addr4)

    # Testing logic for ending contract
    scenario.h1("End")
    
    voterAccount = sp.test_account("Voter")
    candidateAccount = sp.test_account("Canddidate")
    managerAccount = sp.test_account("Manager")
    
    contract = Ballot("End", managerAccount.address, [(candidateAccount.address, "Candidate")], [voterAccount.address], 10)
    
    scenario += contract
    
    # Vote for open voting succeeds
    scenario += contract.vote(votes = {candidateAccount.address: 1}).run(valid = True, sender = voterAccount)
    
    # Ending vote with voterAccount fails
    scenario += contract.end().run(valid = False, sender = voterAccount)
    
    # Ending vote with managerAccount succeeds
    scenario += contract.end().run(valid = True, sender = managerAccount)
    
    # Voting after ending fails
    scenario += contract.vote(votes = {candidateAccount.address: 1}).run(valid = False, sender = voterAccount)
    
    # Ending contract again fails
    scenario += contract.end().run(valid = False, sender = managerAccount)
