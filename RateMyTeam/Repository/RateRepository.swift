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
    case vote(votes: [Candidate.ID: Int], contractAddress: String)
}

struct RateRepositoryState {
    var contracts: [RateContractStorage]
}

final class RateRepository: Repository {
    typealias Dependencies = HasTezosClient & HasUserRepository
        
    @Published var state: RateRepositoryState = RateRepositoryState(contracts: [])
    private let userRepository: AnyRepository<UserRepositoryState, UserRepositoryInput>
    private var cancellables: Set<AnyCancellable> = []
    private let tezosClient: TezosClient
    
    init(dependencies: Dependencies) {
        tezosClient = dependencies.tezosClient
        
        userRepository = dependencies.userRepository
        
        // TODO: Should be saved in UserDefaults
        let initialAddresses: [String] = ["KT1CXpu3S3hypnp3tubiGJLBvyCotxVpMyXE", "KT1RziSJJs4HZYd5E8YMx1EZC9FeyQkCweQD"]
        initialAddresses.forEach {
            updateStore(of: $0)
        }
    }
    
    private func updateStore(of contract: String) {
        tezosClient.rateContract(at: contract)
            .statusPublisher()
            .map(\.storage)
            .map { (contract, $0) }
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
        case let .vote(votes: votes, contractAddress: contractAddress):
            guard let wallet = userRepository.state.value.wallet else { return }
            tezosClient
                .rateContract(at: contractAddress)
                .vote(votes)
                .sendPublisher(from: wallet, amount: Mutez(0))
                .handleEvents(receiveOutput: { output in
                    
                }, receiveCompletion: { completion in
                    
                })
                .startAndStore(in: &cancellables)
        }
    }
}
