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

struct RateContract {
    let candidates: [Candidate]
}

protocol HasRateRepository {
    var rateRepository: RateRepository { get }
}

//protocol RateRepositoring {
//    var actions: RateRepositoringActions { get }
//    var rateContract: RateContract? { get }
//    var rateContractPublished: Published<RateContract?> { get }
//    var rateContractPublisher: Published<RateContract?>.Publisher { get }
//}

//extension RateRepositoring where Self: RateRepositoringActions {
//    var actions: RateRepositoringActions { self }
//}

protocol RateRepositoringActions {
    func updateStore(of contract: String) -> AnyPublisher<RateContract, TezosError>
}

final class RateRepository: RateRepositoringActions, ObservableObject {
    typealias Dependencies = HasTezosClient
    
    @Published var rateContract: RateContract? = nil
    
    private var cancellables: [AnyCancellable] = []
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
    var candidatesPublished: Published<[Candidate]> { get }
    var candidatesPublisher: Published<[Candidate]>.Publisher { get }
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

final class RateViewModel: ViewModel {
    typealias Dependencies = HasRateRepository
    
    @Published private(set) var state: RateState = RateState(candidates: [])
    @ObservedObject private var rateRepository: RateRepository
    
    private var cancellables: [AnyCancellable] = []
    
    init(dependencies: Dependencies) {
        rateRepository = dependencies.rateRepository
        
        dependencies.rateRepository.$rateContract
            .compactMap { $0?.candidates }
            .receive(on: RunLoop.main)
            .assign(to: \.state.candidates, on: self)
            .store(in: &cancellables)
        
        objectWillChange.sink(receiveValue: {
            
        }).store(in: &cancellables)
        
        updateStore()
    }
    
    func trigger(_ input: RateInput) {
        
    }
    
    func updateStore() {
        rateRepository.updateStore(of: "KT1EDS35c3a7unangqgnijm1oSZduuWpRqHP")
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
}
