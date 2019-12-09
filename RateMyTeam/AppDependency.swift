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
    lazy var tezosClient: TezosClient = TezosClient(remoteNodeURL: URL(string: "https://rpczero.tzbeta.net/")!)
    lazy var rateRepository: AnyRepository<RateRepositoryState, RateRepositoryInput> = RateRepository(dependencies: self).eraseToAnyRepository()
}

extension AppDependency: HasTezosClient { }
extension AppDependency: HasRateRepository { }
extension AppDependency: HasRateVMFactory {
    var rateVMFactory: RateVMFactory {
        { RateViewModel(rateContract: $0, dependencies: self).eraseToAnyViewModel() }
    }
}

protocol HasTezosClient {
    var tezosClient: TezosClient { get }
}
