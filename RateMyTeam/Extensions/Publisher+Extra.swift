//
//  Publisher+Extra.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/12/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import Foundation
import Combine

extension Publisher {
    func startAndStore(in set: inout Set<AnyCancellable>) {
        sink(receiveCompletion: { _ in }, receiveValue: { _ in })
        .store(in: &set)
    }
}
