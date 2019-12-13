//
//  RateContract+Extra.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/12/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import Foundation

extension RateContractStatusStorage {
    init(ballot: [String: Ballot], hasEnded: Bool, master: String, totalNumberOfVotes: Int, voters: [String: Int], votesPerVoter: Int) {
        self.ballot = ballot
        self.hasEnded = hasEnded
        self.master = master
        self.totalNumberOfVotes = totalNumberOfVotes
        self.voters = voters
        self.votesPerVoter = votesPerVoter
    }
}
