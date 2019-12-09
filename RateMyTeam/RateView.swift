//
//  RateView.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/2/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import Foundation
import SwiftUI
import TezosSwift
import Combine

enum RateInput {
    
}

struct RateState {
    var candidates: [Candidate]
}

struct RateView: View {
    @ObservedObject var viewModel: AnyViewModel<RateState, RateInput>
    
    var body: some View {
        List(viewModel.state.candidates) {
            Text($0.id)
        }
    }
}

struct RateContract: Identifiable {
    let id: String
    let candidates: [Candidate]
}

protocol HasRateRepository {
    var rateRepository: AnyRepository<RateRepositoryState, RateRepositoryInput> { get }
}

enum RateRepositoryInput {
    case updateStore(String)
}

struct RateRepositoryState {
    var contracts: [RateContract]
}

final class RateRepository: Repository {
    typealias Dependencies = HasTezosClient
        
    @Published var state: RateRepositoryState = RateRepositoryState(contracts: [])
    private var cancellables: Set<AnyCancellable> = []
    private let tezosClient: TezosClient
    
    init(dependencies: Dependencies) {
        tezosClient = dependencies.tezosClient
        
        // TODO: Should be saved in UserDefaults
        let initialAddresses: [String] = ["KT1EDS35c3a7unangqgnijm1oSZduuWpRqHP"]
        initialAddresses.forEach {
            updateStore(of: $0)
        }
    }
    
    private func updateStore(of contract: String) {
        tezosClient.rateContract(at: contract)
            .statusPublisher()
            .map(\.storage)
            .map { (contract, $0.voters.map(Candidate.init)) }
            .map(RateContract.init)
            .map { contract -> RateContract? in return contract }
            .replaceError(with: nil)
            .compactMap { $0 }
            .map { [weak self] in
                self?.updateStore(with: $0)
            }
            .startAndStore(in: &cancellables)
    }
    
    private func updateStore(with contract: RateContract) {
        if let index = state.contracts.firstIndex(where: { $0.id == contract.id }) {
            state.contracts[index] = contract
        } else {
            state.contracts.append(contract)
        }
    }
    
    func trigger(_ input: RateRepositoryInput) {
        switch input {
        case let .updateStore(address):
            updateStore(of: address)
        }
    }
}

extension Publisher {
    func startAndStore(in set: inout Set<AnyCancellable>) {
        sink(receiveCompletion: { _ in }, receiveValue: { _ in })
        .store(in: &set)
    }
}

struct Candidate: Identifiable {
    /// Address
    let id: String
    let numberOfVotes: Int
}
