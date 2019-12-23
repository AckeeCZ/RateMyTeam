//
//  AddContractViewModel.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/19/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import Foundation
import Combine

enum AddContractInput {
    case keyChanged(String)
}

struct AddContractState {
    let inputViewModel: AnyViewModel<InputState, InputViewInput>
    var key: String
}

typealias AddContractVMFactory = () -> AnyViewModel<AddContractState, AddContractInput>

protocol HasAddContractVMFactory {
    var addContractVMFactory: AddContractVMFactory { get }
}

final class AddContractViewModel: ViewModel {
    typealias Dependencies = HasInputVMFactory
    
    @Published var state: AddContractState
    
    private var cancellables: [AnyCancellable] = []
    
    init(dependencies: Dependencies) {
        state = AddContractState(inputViewModel: dependencies.inputVMFactory(),
                                 key: "")
    }
    
    func trigger(_ input: AddContractInput) {
        switch input {
        case let .keyChanged(key):
            state.key = key
        }
    }
}
