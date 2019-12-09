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
    private var cancellables: [AnyCancellable] = []
    private let wrappedTrigger: (Input) -> Void

    let state: CurrentValueSubject<State, Never>

    func trigger(_ input: Input) {
        wrappedTrigger(input)
    }

    init<R: Repository>(_ repository: R) where R.State == State, R.Input == Input {
        self.state = CurrentValueSubject(repository.state)
        self.wrappedTrigger = repository.trigger
    
        repository.objectWillChange
            .eraseToAnyPublisher()
            .sink(receiveValue: { [weak self] in
                self?.objectWillChange.send()
                self?.state.send(repository.state)
            })
            .store(in: &cancellables)
    }
}
