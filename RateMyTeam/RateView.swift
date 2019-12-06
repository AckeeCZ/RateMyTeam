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

struct RateView: View {
    private let viewModel: RateViewModeling
    
    init(viewModel: RateViewModeling) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List(viewModel.candidates) {
            Text($0.id)
        }
    }
}

struct RateContract {
    let candidates: [Candidate]
}

protocol HasRateRepository {
    var rateRepository: RateRepositoring { get }
}

protocol RateRepositoring {
    var actions: RateRepositoringActions { get }
    var rateContract: RateContract? { get }
}

extension RateRepositoring where Self: RateRepositoringActions {
    var actions: RateRepositoringActions { self }
}

protocol RateRepositoringActions {
    func updateStore(of contract: String) -> AnyPublisher<RateContract, TezosError>
}

final class RateRepository: RateRepositoring, RateRepositoringActions, ObservableObject {
    typealias Dependencies = HasTezosClient
    
    @Published var rateContract: RateContract?
    
    private let tezosClient: TezosClient
    
    init(dependencies: Dependencies) {
        tezosClient = dependencies.tezosClient
    }
    
    func updateStore(of contract: String) -> AnyPublisher<RateContract, TezosError> {
        tezosClient.rateContract(at: contract)
            .statusPublisher()
            .map(\.storage)
            .map { $0.voters.map(Candidate.init) }
            .map(RateContract.init)
            .handleEvents(receiveOutput: { [weak self] contract in
                self?.rateContract = contract
            })
            .eraseToAnyPublisher()
    }
}

protocol RateViewModeling {
    var actions: RateViewModelingActions { get }
    var candidates: [Candidate] { get }
}

struct Candidate: Identifiable {
    /// Address
    let id: String
    let numberOfVotes: Int
}

protocol RateViewModelingActions {
    func updateStore()
}

extension RateViewModeling where Self: RateViewModelingActions {
    var actions: RateViewModelingActions { self }
}

final class RateViewModel: RateViewModeling, RateViewModelingActions, ObservableObject {
    typealias Dependencies = HasRateRepository
    
    @Published var candidates: [Candidate]
    
    private var updateStoreCancellable: AnyCancellable?
    
    private let rateRepository: RateRepositoring
    
    init(dependencies: Dependencies) {
        rateRepository = dependencies.rateRepository
        
        candidates = rateRepository.rateContract?.candidates ?? []
        
        updateStore()
    }
    
    func updateStore() {
        updateStoreCancellable = rateRepository.actions.updateStore(of: "KT1EDS35c3a7unangqgnijm1oSZduuWpRqHP").sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case let .failure(error):
                print(error)
            }
        }, receiveValue: { value in
            
        })
    }
}
