//
//  AnyRepository.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/6/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import Foundation
import Combine

protocol Repository: ObservableObject where ObjectWillChangePublisher.Output == Void {
    associatedtype State
    associatedtype Input

    var state: State { get }
    func trigger(_ input: Input)
}

extension Repository {
    func eraseToAnyRepository() -> AnyRepository<State, Input> {
        AnyRepository(self)
    }
}

final class AnyRepository<State, Input>: ObservableObject {
    let objectWillChange = ObservableObjectPublisher()
//    private let wrappedObjectWillChange: () -> AnyPublisher<Void, Never>
    private var cancellables: [AnyCancellable] = []
    private let wrappedState: () -> State
    private let wrappedTrigger: (Input) -> Void

    var state: State {
        wrappedState()
    }

    func trigger(_ input: Input) {
        wrappedTrigger(input)
    }

    init<R: Repository>(_ repository: R) where R.State == State, R.Input == Input {
        self.wrappedState = { repository.state }
        self.wrappedTrigger = repository.trigger
    
        repository.objectWillChange
            .eraseToAnyPublisher()
            .sink(receiveValue: { [weak self] in self?.objectWillChange.send() })
            .store(in: &cancellables)
    }
    
    deinit {
        
    }
}
