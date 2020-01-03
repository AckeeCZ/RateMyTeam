import smartpy as sp

class Ballot(sp.Contract):
    def __init__(self, name, creator, candidates, voters, numberOfVotes):
        initialBallot = {}
        for candidate in candidates:
            initialBallot[candidate[0]] = sp.record(candidateName = candidate[1], numberOfVotes = 0)
        initialVoters = { }
        for voter in voters:
            initialVoters[voter] = numberOfVotes
        self.init(name = name, master = creator, ballot = initialBallot, voters = initialVoters, hasEnded = False, totalNumberOfVotes = 0, votesPerVoter = numberOfVotes)
        

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
        sp.verify(sp.sender == self.data.master)
        sp.verify(self.data.hasEnded == False)
        sp.for candidate in self.data.ballot.keys():
            sp.if self.data.ballot[candidate].numberOfVotes != 0:
                sp.send(candidate, sp.splitTokens(sp.balance, sp.as_nat(self.data.ballot[candidate].numberOfVotes), sp.as_nat(self.data.totalNumberOfVotes)))
        self.data.hasEnded = True

        
@sp.add_test(name = "CandidatesTest")
def test():
    scenario = sp.test_scenario()
    scenario.h1("Candidates")
    
    addr1 = sp.address("tz1VsSC7ZUxpTt9t18Cuae9NeL2xWTgX7Mix")
    addr2 = sp.address("tz1MNXmdB6mPGx1yifwaxhbpiL9sjE2W2BLG")
    addr3 = sp.address("tz1c2mnLJSwUYHNytq1XZ9YQT81ojca7YDYY")
    addr4 = sp.address("tz1c2mnLJSwUYHNytq1XZ9YQT81ojca7YDYY")
    addr5 = sp.address("tz1c2mnLJSwUYHNytq1XZ9YQT81ojca7YDYY")
    addr6 = sp.address("tz1c2mnLJSwUYHNytq1XZ9YQT81ojca7YDYY")
    
    contract = Ballot("Design", addr5, [(addr1, "Winner"), (addr2, "Jirka"), (addr3, "Pepus")], [addr4, addr6], 100)
    #sp.send(contract, sp.tez(1))

    scenario += contract
    
    #scenario += contract.vote(votes = {addr1: 1}).run(valid=False,sender = addr4)
    
    #scenario += contract.end().run(valid=False, sender = addr4)
    #scenario += contract.end().run(sender = addr5)
    #scenario += contract.end().run(sender = addr5)
    
    
    
    
    
    