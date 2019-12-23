//
//  Candidate+Preview.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/13/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import Foundation

#if DEBUG
extension Candidate {
    static func preview() -> Candidate {
        Candidate(address: "tz908980sdsd9000090909", numberOfVotes: 2, currentlyPlacedVotes: 0, name: "Charles")
    }
}
#endif
