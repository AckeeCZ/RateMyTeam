//
//  RateContractStorage.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/12/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import Foundation

struct RateContractStorage: Identifiable {
    let id: String
    let candidates: [Candidate]
}
