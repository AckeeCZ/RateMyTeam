//
//  AnyViewModel.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/6/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import Foundation
import Combine

/// Taken from: https://quickbirdstudios.com/blog/swiftui-architecture-redux-mvvm/
protocol ViewModel: ObservableObject where ObjectWillChangePublisher.Output == Void {
    associatedtype State
    associatedtype Input

    var state: State { get }
    func trigger(_ input: Input)
}

extension ViewModel {
    func eraseToAnyViewModel() -> AnyViewModel<State, Input> {
        AnyViewModel(self)
    }
}

final class Seg<State>: ObservableObject {
    @Published var mo: State?
}

//final class Segg<T>: ObservableObject {
//    @Published var mo: T?
//}

final class AnyViewModel<State, Input>: ObservableObject {
    // Workaround, bug in Combine
    let objectWillChange = ObservableObjectPublisher()
    private var cancellables: [AnyCancellable] = []
    private let wrappedState: () -> State
    private let wrappedTrigger: (Input) -> Void

    var state: State {
        wrappedState()
    }

    func trigger(_ input: Input) {
        wrappedTrigger(input)
    }

    init<V: ViewModel>(_ viewModel: V) where V.State == State, V.Input == Input {
        self.wrappedState = { viewModel.state }
        self.wrappedTrigger = viewModel.trigger
    
        viewModel.objectWillChange
            .eraseToAnyPublisher()
            .sink(receiveValue: { [weak self] in self?.objectWillChange.send() })
            .store(in: &cancellables)
    }
    
    deinit {
        
    }
}
