//
//  InputViewModel.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/16/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import Foundation
import class UIKit.UIPasteboard
import Combine

enum InputViewInput {
    case textChanged(String)
    case pasteClipboard
}

struct InputState {
    var text: String
}

typealias InputVMFactory = () -> AnyViewModel<InputState, InputViewInput>

protocol HasInputVMFactory {
    var inputVMFactory: InputVMFactory { get }
}

final class InputViewModel: ViewModel {
    typealias Dependencies = HasNoDependency
    
    @Published var state: InputState
    
    private var cancellables: [AnyCancellable] = []
    
    init(dependencies: Dependencies) {
        self.state = InputState(text: "")
    }
    
    func trigger(_ input: InputViewInput) {
        switch input {
        case let .textChanged(text):
            state.text = text
        case .pasteClipboard:
            guard let pasteboard = UIPasteboard.general.string else { return }
            state.text = pasteboard
        }
    }
}
