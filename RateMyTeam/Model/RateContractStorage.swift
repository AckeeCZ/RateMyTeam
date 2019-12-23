//
//  RateContractStorage.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/12/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import Foundation

struct RateContractStorage: Identifiable {
    init(address: String, storage: RateContractStatusStorage) {
        self.contract = address
        self.candidates = storage.ballot.map { Candidate(address: $0.key, numberOfVotes: $0.value.numberOfVotes, currentlyPlacedVotes: 0, name: $0.value.candidateName) }
        self.voters = storage.voters.map(Voter.init)
        self.totalNumberOfVotes = Int(storage.totalNumberOfVotes)
        self.votesPerVoter = storage.votesPerVoter
        
    }
    var id: String {
        contract
    }
    let contract: String
    var candidates: [Candidate]
    var voters: [Voter]
    var totalNumberOfVotes: Int
    let votesPerVoter: Int
}

struct Voter: Identifiable {
    var id: String {
        address
    }
    let address: String
    var numberOfVotesLeft: Int
}
