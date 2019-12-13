//
//  RateViewModel.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/6/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import Foundation
import Combine

enum RateInput {
    
}

struct RateState {
    var candidates: [Candidate]
    var totalNumberOfVotes: Int
    var votesLeft: Int
    let title: String
}

typealias RateVMFactory = (RateContractStorage) -> AnyViewModel<RateState, RateInput>

protocol HasRateVMFactory {
    var rateVMFactory: RateVMFactory { get }
}

final class RateViewModel: ViewModel {
    typealias Dependencies = HasRateRepository
    
    @Published private(set) var state: RateState
    private let rateRepository: AnyRepository<RateRepositoryState, RateRepositoryInput>
    
    private var cancellables: [AnyCancellable] = []
    
    init(rateContract: RateContractStorage, dependencies: Dependencies) {
        rateRepository = dependencies.rateRepository
        
        state = RateState(candidates: rateContract.candidates,
                          totalNumberOfVotes: 0,
                          votesLeft: 0,
                          title: rateContract.id)
        
        let contractPublisher = dependencies.rateRepository.state
            .compactMap { $0.contracts.first(where: { $0.id == rateContract.id }) }
            .receive(on: RunLoop.main)
        
        contractPublisher
            .map(\.totalNumberOfVotes)
            .assign(to: \.state.totalNumberOfVotes, on: self)
            .store(in: &cancellables)
        
        contractPublisher
            .map(\.candidates)
            .assign(to: \.state.candidates, on: self)
            .store(in: &cancellables)
        
        contractPublisher
            .map(\.voters)
            .map { $0.first(where: { $0.address == myAddress })?.numberOfVotesLeft ?? 0 }
            .assign(to: \.state.votesLeft, on: self)
            .store(in: &cancellables)
    
        updateStore()
    }
    
    func trigger(_ input: RateInput) {
        
    }
    
    func updateStore() {
//        rateRepository.updateStore(of: "KT1EDS35c3a7unangqgnijm1oSZduuWpRqHP")
//            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
//            .store(in: &cancellables)
    }
}
