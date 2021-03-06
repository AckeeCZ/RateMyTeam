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
    case placeVotes(candidate: Candidate.ID, numberOfVotes: Int, contractAddress: String)
    case vote(votes: [Candidate.ID: Int], contractAddress: String)
    case addContract(String)
    case endVote(String)
}

struct RateRepositoryState {
    var contracts: [RateContractStorage]
}

final class RateRepository: Repository {
    typealias Dependencies = HasTezosClient & HasUserRepository
        
    @Storage(key: "contracts", defaultValue: [])
    private var contracts: [String]
    @Published var state: RateRepositoryState = RateRepositoryState(contracts: [])
    private let userRepository: AnyRepository<UserRepositoryState, UserRepositoryInput>
    private var cancellables: Set<AnyCancellable> = []
    private let tezosClient: TezosClient
    
    init(dependencies: Dependencies) {
        tezosClient = dependencies.tezosClient
        
        userRepository = dependencies.userRepository
        
        contracts.forEach {
            updateStore(of: $0)
        }
    }
    
    func trigger(_ input: RateRepositoryInput) {
        switch input {
        case let .updateStore(address):
            updateStore(of: address)
        case let .placeVotes(candidate: candidate, numberOfVotes: numberOfVotes, contractAddress: contractAddress):
            guard
                let contractIndex = state.contracts.firstIndex(where: { $0.id == contractAddress }),
                let candidateIndex = state.contracts[contractIndex].candidates.firstIndex(where: { $0.id == candidate })
            else { return }
            state.contracts[contractIndex].candidates[candidateIndex].currentlyPlacedVotes = numberOfVotes
        case let .vote(votes: votes, contractAddress: contractAddress):
            vote(votes: votes, contractAddress: contractAddress)
        case let .addContract(contract):
            contracts.append(contract)
            updateStore(of: contract)
        case let .endVote(contractAddress):
            endVote(contractAddress)
        }
    }
    
    // MARK: - Helpers
    
    private func vote(votes: [Candidate.ID: Int], contractAddress: String) {
        guard let wallet = userRepository.state.value.wallet else { return }
        let nonZeroVotes = votes.filter { $0.value != 0 }
        tezosClient
            .rateContract(at: contractAddress)
            .vote(nonZeroVotes)
            .callPublisher(from: wallet, amount: Tez(0))
            .handleEvents(receiveOutput: { [weak self] output in
                print(output)
                self?.addVotes(votes, for: contractAddress)
            }, receiveCompletion: { completion in
                print(completion)
            })
            .startAndStore(in: &cancellables)
    }
    
    private func endVote(_ contractAddress: String) {
        guard let wallet = userRepository.state.value.wallet else { return }
        tezosClient
            .rateContract(at: contractAddress)
            .end()
            .callPublisher(from: wallet, amount: Tez(0))
            .handleEvents(receiveOutput: { [weak self] output in
                print(output)
                self?.endVote(of: contractAddress)
            }, receiveCompletion: { completion in
                print(completion)
            })
            .startAndStore(in: &cancellables)
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
    
    private func addVotes(_ votes: [Candidate.ID: Int], for contract: String) {
        guard let index = state.contracts.firstIndex(where: { $0.id == contract }) else { return }
        votes.forEach { id, votes in
            guard let candidateIndex = state.contracts[index].candidates.firstIndex(where: { $0.id == id }) else { return }
            state.contracts[index].candidates[candidateIndex].numberOfVotes += votes
            state.contracts[index].candidates[candidateIndex].currentlyPlacedVotes = 0
        }
        
        guard
            let wallet = userRepository.state.value.wallet,
            let voterIndex = state.contracts[index].voters.firstIndex(where: { $0.id == wallet.address })
        else { return }
        let totalNumberOfNewVotes = votes.reduce(0, { count, vote in count + vote.value })
        state.contracts[index].totalNumberOfVotes += totalNumberOfNewVotes
        state.contracts[index].voters[voterIndex].numberOfVotesLeft -= totalNumberOfNewVotes
    }
    
    private func endVote(of contract: String) {
        guard let index = state.contracts.firstIndex(where: { $0.id == contract }) else { return }
        state.contracts[index].hasEnded = true
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
}
