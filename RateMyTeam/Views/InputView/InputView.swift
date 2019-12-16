//
//  InputView.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/16/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import SwiftUI
import Combine

protocol InputFlowDelegate {
    func textChanged(_ newText: String)
}

struct InputView: View {
    @ObservedObject var viewModel: AnyViewModel<InputState, InputViewInput>
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: AnyViewModel<InputState, InputViewInput>, delegate: InputFlowDelegate) {
        self.viewModel = viewModel
        // TODO: This could probably be a subscription :thinking:
        viewModel.stateChanges
            .handleEvents(receiveOutput: {
                delegate.textChanged($0.text)
            }).startAndStore(in: &cancellables)
    }
    
    var body: some View {
        VStack {
            HStack {
                ZStack(alignment: .leading) {
                    if viewModel.state.text.isEmpty { Text("Enter your key").foregroundColor(.white) }
                    TextField("", text: Binding(get: { self.viewModel.state.text },
                                                set: { self.viewModel.trigger(.textChanged($0)) }))
                        .foregroundColor(.white)
                }
                
                Button(action: {
                    self.viewModel.trigger(.pasteClipboard)
                }) {
                    Text("PASTE")
                        .theme.font(.sectionTitle)
                        .foregroundColor(Color.white)
                        .opacity(0.4)
                }
                Image(Asset.paste.name)
            }
            HStack {
                Color.white.frame(height: 2)
            }
        }
    }
}

#if DEBUG

struct InputDelegatePreview: InputFlowDelegate {
    func textChanged(_ newText: String) {
        
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(viewModel: InputViewModel(dependencies: dependencies).eraseToAnyViewModel(),
                  delegate: InputDelegatePreview())
    }
}
#endif
