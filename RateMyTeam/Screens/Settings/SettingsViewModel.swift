//
//  SettingsViewModel.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 1/3/20.
//  Copyright © 2020 Marek Fořt. All rights reserved.
//

import Foundation
import Combine

enum SettingsInput {
    case logout
}

struct SettingsState: Equatable {
    let myWalletAddress: String
}

typealias SettingsVMFactory = () -> AnyViewModel<SettingsState, SettingsInput>

protocol HasSettingsVMFactory {
    var settingsVMFactory: SettingsVMFactory { get }
}

final class SettingsViewModel: ViewModel {
    typealias Dependencies = HasUserRepository
    
    @Published var state: SettingsState
    private let userRepository: AnyRepository<UserRepositoryState, UserRepositoryInput>
    private var cancellables: [AnyCancellable] = []

    init(dependencies: Dependencies) {
        userRepository = dependencies.userRepository
        
        state = SettingsState(myWalletAddress: dependencies.userRepository.state.value.wallet?.address ?? "")
    }
    
    func trigger(_ input: SettingsInput) {
        switch input {
        case .logout:
            userRepository.trigger(.deleteWallet)
        }
    }
}
