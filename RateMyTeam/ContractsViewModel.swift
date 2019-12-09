//
//  ContractsViewModel.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/6/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import Foundation
import Combine

enum ContractsInput {
    case rateVM(contract: RateContract)
}

struct ContractsState {
    var contracts: [RateContract]
}

final class ContractsViewModel: ViewModel {
    typealias Dependencies = HasRateRepository & HasRateVMFactory
    
    @Published private(set) var state: ContractsState = ContractsState(contracts: [])
    private let rateRepository: AnyRepository<RateRepositoryState, RateRepositoryInput>
    
    private var cancellables: [AnyCancellable] = []
    
    init(dependencies: Dependencies) {
        rateRepository = dependencies.rateRepository
        
        dependencies.rateRepository.state
            .map(\.contracts)
            .receive(on: RunLoop.main)
            .assign(to: \.state.contracts, on: self)
            .store(in: &cancellables)
    }
    
    func trigger(_ input: ContractsInput) {
        switch input {
        case let .rateVM(contract):
            
        }
    }
}
