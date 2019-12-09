//
//  ContractsViewModel.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/6/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import Foundation
import Combine

final class ContractsViewModel: ViewModel {
    typealias Dependencies = HasRateRepository
    
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
        
    }
}
