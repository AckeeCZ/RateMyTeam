//
//  Candidate.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/12/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import Foundation

struct Candidate: Identifiable {
    /// Address
    let address: String
    var id: String {
        address
    }
    var numberOfVotes: Int
    var currentlyPlacedVotes: Int
    let name: String
}
