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
        

    @sp.entryPoint
    def vote(self, params):
        sp.verify(self.data.hasEnded == False)
        sp.verify(self.data.voters.contains(sp.sender))
        sp.for vote in params.votes.items():
            sp.verify(self.data.voters[sp.sender] >= vote.value)
            self.data.ballot[vote.key].numberOfVotes += vote.value
            self.data.voters[sp.sender] -= vote.value
            self.data.totalNumberOfVotes += vote.value
        
        
    @sp.entryPoint
    def end(self, params):
        sp.verify(sp.sender == self.data.master)
        sp.verify(self.data.hasEnded == False)
        sp.for candidate in self.data.ballot.keys():
            sp.if self.data.ballot[candidate].numberOfVotes != 0:
                sp.send(candidate, sp.splitTokens(sp.balance, sp.asNat(self.data.ballot[candidate].numberOfVotes), sp.asNat(self.data.totalNumberOfVotes)))
        self.data.hasEnded = True

        
@addTest(name = "CandidatesTest")
def test():
    scenario = sp.testScenario()
    scenario.h1("Candidates")
    
    addr1 = sp.address("tz1VsSC7ZUxpTt9t18Cuae9NeL2xWTgX7Mix")
    addr2 = sp.address("tz1MNXmdB6mPGx1yifwaxhbpiL9sjE2W2BLG")
    addr3 = sp.address("tz1c2mnLJSwUYHNytq1XZ9YQT81ojca7YDYY")
    addr4 = sp.address("tz1c2mnLJSwUYHNytq1XZ9YQT81ojca7YDYY")
    addr5 = sp.address("tz1c2mnLJSwUYHNytq1XZ9YQT81ojca7YDYY")
    addr6 = sp.address("tz1c2mnLJSwUYHNytq1XZ9YQT81ojca7YDYY")
    
    contract = Ballot("Design", addr5, [(addr1, "George"), (addr2, "Tim"), (addr3, "Gina")], [addr4, addr6], 100)

    scenario += contract
