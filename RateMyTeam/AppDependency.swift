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
    lazy var rateRepository: AnyRepository<RateRepositoryState, RateRepositoryInput> = RateRepository(dependencies: self).eraseToAnyRepository()
    lazy var userRepository: AnyRepository<UserRepositoryState, UserRepositoryInput> = UserRepository(dependencies: self).eraseToAnyRepository()
}

protocol HasNoDependency { }

extension AppDependency: HasNoDependency { }
extension AppDependency: HasTezosClient { }
extension AppDependency: HasRateRepository { }
extension AppDependency: HasUserRepository { }
extension AppDependency: HasRateVMFactory {
    var rateVMFactory: RateVMFactory {
        { RateViewModel(rateContract: $0, dependencies: self).eraseToAnyViewModel() }
    }
}

extension AppDependency: HasVoteVMFactory {
    var voteVMFactory: VoteVMFactory {
        { VoteViewModel(rateContract: $0, dependencies: self).eraseToAnyViewModel() }
    }
}

extension AppDependency: HasLoginVMFactory {
    var loginVMFactory: LoginVMFactory {
        { LoginViewModel(dependencies: self).eraseToAnyViewModel() }
    }
}

extension AppDependency: HasInputVMFactory {
    var inputVMFactory: InputVMFactory {
        { InputViewModel(dependencies: self).eraseToAnyViewModel() }
    }
}

extension AppDependency: HasAddContractVMFactory {
    var addContractVMFactory: AddContractVMFactory {
        { AddContractViewModel(dependencies: self).eraseToAnyViewModel() }
    }
}

protocol HasTezosClient {
    var tezosClient: TezosClient { get }
}
