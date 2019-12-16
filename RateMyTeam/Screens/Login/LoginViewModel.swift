//
//  LoginViewModel.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/16/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import Foundation
import Combine

enum LoginInput {
    case keyChanged(String)
    case enter
}

struct LoginState {
    let inputViewModel: AnyViewModel<InputState, InputViewInput>
    var key: String
}

typealias LoginVMFactory = () -> AnyViewModel<LoginState, LoginInput>

protocol HasLoginVMFactory {
    var loginVMFactory: LoginVMFactory { get }
}

final class LoginViewModel: ViewModel {
    typealias Dependencies = HasInputVMFactory & HasUserRepository
    
    @Published var state: LoginState
    
    private let userRepository: AnyRepository<UserRepositoryState, UserRepositoryInput>
    private var cancellables: [AnyCancellable] = []
    
    init(dependencies: Dependencies) {
        state = LoginState(inputViewModel: dependencies.inputVMFactory(),
                            key: "")
        userRepository = dependencies.userRepository
    }
    
    func trigger(_ input: LoginInput) {
        switch input {
        case let .keyChanged(key):
            state.key = key
        case .enter:
            userRepository.trigger(.addWallet(secretKey: state.key))
        }
    }
}
