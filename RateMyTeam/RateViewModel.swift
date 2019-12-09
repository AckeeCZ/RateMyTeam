//
//  RateViewModel.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/6/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import Foundation
import Combine

final class RateViewModel: ViewModel {
    typealias Dependencies = HasRateRepository
    
    @Published private(set) var state: RateState = RateState(candidates: [])
    private let rateRepository: AnyRepository<RateRepositoryState, RateRepositoryInput>
    
    private var cancellables: [AnyCancellable] = []
    
    init(dependencies: Dependencies) {
        rateRepository = dependencies.rateRepository
        
//        dependencies.rateRepository.$rateContract
//            .compactMap { $0?.candidates }
//            .receive(on: RunLoop.main)
//            .assign(to: \.state.candidates, on: self)
//            .store(in: &cancellables)
        
        objectWillChange.sink(receiveValue: {
            
        }).store(in: &cancellables)
        
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
