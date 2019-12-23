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
    case votesCountChanged(candidate: Candidate, count: Int)
    case vote
}

struct RateState {
    var candidates: [Candidate]
    var votesForCandidates: [Candidate.ID: Int]
    var hasNewVotesForCandidates: [Candidate.ID: Bool]
    var hasPlacedVotes: Bool
    var totalNumberOfVotes: Int
    var votesLeft: Int
    var votesPerVoter: Int
    var maximumNumberOfVotes: Int
    let title: String
    let voteViewModel: AnyViewModel<VoteState, VoteInput>
}

typealias RateVMFactory = (RateContractStorage) -> AnyViewModel<RateState, RateInput>

protocol HasRateVMFactory {
    var rateVMFactory: RateVMFactory { get }
}

final class RateViewModel: ViewModel {
    typealias Dependencies = HasRateRepository & HasVoteVMFactory & HasUserRepository
    
    @Published var state: RateState
    private let contractAddress: String
    private let rateRepository: AnyRepository<RateRepositoryState, RateRepositoryInput>
    private let userRepository: AnyRepository<UserRepositoryState, UserRepositoryInput>
    
    private var cancellables: [AnyCancellable] = []
    
    init(rateContract: RateContractStorage, dependencies: Dependencies) {
        rateRepository = dependencies.rateRepository
        userRepository = dependencies.userRepository
        
        contractAddress = rateContract.contract
        
        state = RateState(candidates: rateContract.candidates,
                          votesForCandidates: [:],
                          hasNewVotesForCandidates: [:],
                          hasPlacedVotes: false,
                          totalNumberOfVotes: 0,
                          votesLeft: 0,
                          votesPerVoter: 0,
                          maximumNumberOfVotes: 0,
                          title: rateContract.id,
                          voteViewModel: dependencies.voteVMFactory(rateContract))
        
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
            .map { $0.first(where: { $0.address == dependencies.userRepository.state.value.wallet?.address })?.numberOfVotesLeft ?? 0 }
            .assign(to: \.state.votesLeft, on: self)
            .store(in: &cancellables)
        
        contractPublisher
            .map(\.votesPerVoter)
            .assign(to: \.state.votesPerVoter, on: self)
            .store(in: &cancellables)
        
        contractPublisher
            .map { $0.voters.count * $0.votesPerVoter }
            .assign(to: \.state.maximumNumberOfVotes, on: self)
            .store(in: &cancellables)
        
        contractPublisher
            .map { $0.candidates.reduce([:], { current, candidate in
                var mutable = current
                mutable[candidate.id] = candidate.numberOfVotes + candidate.currentlyPlacedVotes
                return mutable
            })}
            .assign(to: \.state.votesForCandidates, on: self)
            .store(in: &cancellables)
        
        contractPublisher
            .map { $0.candidates.reduce([:], { current, candidate in
                var mutable = current
                mutable[candidate.id] = candidate.currentlyPlacedVotes != 0
                return mutable
            })
        }
            .assign(to: \.state.hasNewVotesForCandidates, on: self)
            .store(in: &cancellables)
        
        contractPublisher
            .map(\.candidates)
            .map { $0.first(where: { $0.currentlyPlacedVotes != 0 }) != nil }
            .assign(to: \.state.hasPlacedVotes, on: self)
            .store(in: &cancellables)
    }
    
    func trigger(_ input: RateInput) {
        switch input {
        case let .votesCountChanged(candidate: candidate, count: count):
            rateRepository.trigger(.placeVotes(candidate: candidate.id,
                                               numberOfVotes: count,
                                               contractAddress: contractAddress))
        case .vote:
            let currentlyPlacedVotes: [Candidate.ID: Int] = state.candidates.reduce([:], { current, candidate in
                var mutable = current
                mutable[candidate.id] = candidate.currentlyPlacedVotes
                return mutable
            })
            rateRepository.trigger(.vote(votes: currentlyPlacedVotes,
                                         contractAddress: contractAddress))
        }
    }
}
