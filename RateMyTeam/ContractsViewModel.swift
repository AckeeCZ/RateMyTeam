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
    
}

struct ContractsState {
    struct ContractData: Identifiable {
        var id: String {
            contract.id
        }
        let contract: RateContract
        let viewModel: AnyViewModel<RateState, RateInput>
    }
    var contracts: [ContractData]
}

final class ContractsViewModel: ViewModel {
    typealias Dependencies = HasRateRepository & HasRateVMFactory
    
    @Published private(set) var state: ContractsState = ContractsState(contracts: [])
    private let rateRepository: AnyRepository<RateRepositoryState, RateRepositoryInput>
    
    private var cancellables: [AnyCancellable] = []
    
    init(dependencies: Dependencies) {
        rateRepository = dependencies.rateRepository
        
        dependencies.rateRepository.state
            .map { $0.contracts.map { ($0, dependencies.rateVMFactory($0)) } }
            .map { $0.map(ContractsState.ContractData.init) }
            .receive(on: RunLoop.main)
            .assign(to: \.state.contracts, on: self)
            .store(in: &cancellables)
    }
    
    func trigger(_ input: ContractsInput) {
        
    }
}
