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
    typealias Dependencies = HasInputVMFactory
    
    @Published var state: LoginState
    
    private var cancellables: [AnyCancellable] = []
    
    init(dependencies: Dependencies) {
        self.state = LoginState(inputViewModel: dependencies.inputVMFactory(),
                                key: "")
    }
    
    func trigger(_ input: LoginInput) {
        switch input {
        case let .keyChanged(key):
            state.key = key
        }
    }
}
