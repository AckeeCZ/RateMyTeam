//
//  AppDependency.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/2/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import Foundation
import TezosSwift

let dependencies = AppDependency()

/// Container for all app dependencies
final class AppDependency {
    lazy var tezosClient: TezosClient = TezosClient(remoteNodeURL: URL(string: "https://rpcalpha.tzbeta.net/")!)
    lazy var rateRepository: RateRepository = RateRepository(dependencies: self)
}

extension AppDependency: HasTezosClient { }
extension AppDependency: HasRateRepository { }

protocol HasTezosClient {
    var tezosClient: TezosClient { get }
}
