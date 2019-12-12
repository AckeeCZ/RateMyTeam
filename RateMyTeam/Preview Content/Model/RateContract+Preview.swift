//
//  RateContract.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/12/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import Foundation

#if DEBUG
extension RateContractStorage {
    static func preview() -> RateContractStorage {
        RateContractStorage(id: "KT098098dsf98908", candidates: [
            Candidate(id: "KT9889899SSi", numberOfVotes: 2)
        ])
    }
}
#endif
