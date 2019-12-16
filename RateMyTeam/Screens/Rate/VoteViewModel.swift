//
//  ViewModel.swift
//  VoteMyTeam
//
//  Created by Marek Fořt on 12/15/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import Foundation
import Combine

enum VoteInput {
    case incrementVote
    case decrementVote
}

struct VoteState: Equatable {
    var votesCount: Int
    var maxNumberOfVotes: Int
    var canSendVotes: Bool
}

typealias VoteVMFactory = (RateContractStorage) -> AnyViewModel<VoteState, VoteInput>

protocol HasVoteVMFactory {
    var voteVMFactory: VoteVMFactory { get }
}

final class VoteViewModel: ViewModel {
    typealias Dependencies = HasRateRepository & HasUserRepository
    
    @Published var state: VoteState
    private let rateRepository: AnyRepository<RateRepositoryState, RateRepositoryInput>
    private var cancellables: [AnyCancellable] = []

    init(rateContract: RateContractStorage, dependencies: Dependencies) {
        self.state = VoteState(votesCount: 0, maxNumberOfVotes: 0, canSendVotes: false)
        self.rateRepository = dependencies.rateRepository
        
        let contractPublisher = dependencies.rateRepository.state
            .compactMap { $0.contracts.first(where: { $0.id == rateContract.id }) }
            .receive(on: RunLoop.main)
        
        contractPublisher
            .map(\.voters)
            .map { $0.first(where: { $0.address == dependencies.userRepository.state.value.wallet?.address })?.numberOfVotesLeft ?? 0 }
            .assign(to: \.state.maxNumberOfVotes, on: self)
            .store(in: &cancellables)
        
        $state
            .removeDuplicates()
            .map(\.votesCount)
            .map { $0 != 0 }
            .assign(to: \.state.canSendVotes, on: self)
            .store(in: &cancellables)
    }
    
    func trigger(_ input: VoteInput) {
        switch input {
        case .incrementVote:
            state.votesCount += 1
        case .decrementVote:
            state.votesCount -= 1
        }
    }
}
