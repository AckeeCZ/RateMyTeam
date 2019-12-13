//
//  RateContract.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/12/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import Foundation
import TezosSwift

#if DEBUG
extension RateContractStorage {
    static func preview() -> RateContractStorage {
        RateContractStorage(address: "KT098098dsf98908", storage: RateContractStatusStorage(ballot: ["KT909090": Ballot(TezosPair<String, Int>(first: "Name", second: 2)!)],
                                                                                            hasEnded: false,
                                                                                            master: "",
                                                                                            totalNumberOfVotes: 4,
                                                                                            voters: ["tz098098098fsd999": 3],
                                                                                            votesPerVoter: 10))
    }
}
#endif
