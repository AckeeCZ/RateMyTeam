//
//  RateRepository.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/9/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import Foundation
import Combine
import TezosSwift

protocol HasRateRepository {
    var rateRepository: AnyRepository<RateRepositoryState, RateRepositoryInput> { get }
}

enum RateRepositoryInput {
    case updateStore(String)
}

struct RateRepositoryState {
    var contracts: [RateContractStorage]
}

final class RateRepository: Repository {
    typealias Dependencies = HasTezosClient
        
    @Published var state: RateRepositoryState = RateRepositoryState(contracts: [])
    private var cancellables: Set<AnyCancellable> = []
    private let tezosClient: TezosClient
    
    init(dependencies: Dependencies) {
        tezosClient = dependencies.tezosClient
        
        // TODO: Should be saved in UserDefaults
        let initialAddresses: [String] = ["KT1G9m32rZzU4B9WM8kKoTTDy8LU7HXt2qeW", "KT1PzWM1NkejHMaPMrGFLM5BPTEtbCZegGp5"]
        initialAddresses.forEach {
            updateStore(of: $0)
        }
    }
    
    private func updateStore(of contract: String) {
        tezosClient.rateContract(at: contract)
            .statusPublisher()
            .map(\.storage)
            .map { (contract, $0.voters.map(Candidate.init)) }
            .map(RateContractStorage.init)
            .map { contract -> RateContractStorage? in return contract }
            .handleEvents(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    print(error)
                case .finished:
                    break
                }
            })
            .replaceError(with: nil)
            .compactMap { $0 }
            .map { [weak self] in
                self?.updateStore(with: $0)
            }
            .startAndStore(in: &cancellables)
    }
    
    private func updateStore(with contract: RateContractStorage) {
        if let index = state.contracts.firstIndex(where: { $0.id == contract.id }) {
            state.contracts[index] = contract
        } else {
            state.contracts.append(contract)
            // Append alone does not trigger `objectWillChange`
            state.contracts = state.contracts
        }
        
    }
    
    func trigger(_ input: RateRepositoryInput) {
        switch input {
        case let .updateStore(address):
            updateStore(of: address)
        }
    }
}
