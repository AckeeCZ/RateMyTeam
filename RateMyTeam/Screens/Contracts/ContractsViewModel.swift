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
        let contract: RateContractStorage
        let viewModel: AnyViewModel<RateState, RateInput>
    }
    var contracts: [ContractData]
    var pastContracts: [ContractData]
    let addContractViewModel: AnyViewModel<AddContractState, AddContractInput>
}

final class ContractsViewModel: ViewModel {
    typealias Dependencies = HasRateRepository & HasRateVMFactory & HasAddContractVMFactory
    
    @Published var state: ContractsState
    private let rateRepository: AnyRepository<RateRepositoryState, RateRepositoryInput>
    
    private var cancellables: [AnyCancellable] = []
    
    init(dependencies: Dependencies) {
        rateRepository = dependencies.rateRepository
        
        state = ContractsState(contracts: [], pastContracts: [], addContractViewModel: dependencies.addContractVMFactory())
        
        let allContractsPublisher = dependencies.rateRepository.state
            .map { $0.contracts.map { ($0, dependencies.rateVMFactory($0)) } }
            .map { $0.map(ContractsState.ContractData.init) }
            .receive(on: RunLoop.main)
        
        allContractsPublisher
            .map { $0.filter { !$0.contract.hasEnded } }
            .assign(to: \.state.contracts, on: self)
            .store(in: &cancellables)
        
        allContractsPublisher
            .map { $0.filter { $0.contract.hasEnded } }
            .assign(to: \.state.pastContracts, on: self)
            .store(in: &cancellables)
    }
    
    func trigger(_ input: ContractsInput) {
        
    }
}
