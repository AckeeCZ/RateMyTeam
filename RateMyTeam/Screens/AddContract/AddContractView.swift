//
//  AddContractView.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/19/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import SwiftUI

struct AddContractView: View {
    @ObservedObject var viewModel: AnyViewModel<AddContractState, AddContractInput>
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            InputView(viewModel: viewModel.state.inputViewModel,
                      delegate: self,
                      textColor: .black,
                      themeColor: Color(Color.theme.blue.color),
                      pasteColor: Color(Color.theme.blue.color))
            HStack {
                Button(action: {
                    self.viewModel.trigger(.addContract)
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Add")
                }
                .theme.buttonStyle(.default)
                Spacer()
            }
            Spacer()
        }
        .padding([.leading, .trailing], 16)
        .padding(.top, 38)
        .padding(.bottom, 24)
        .navigationBarTitle("Add voting", displayMode: .inline)
    }
}

extension AddContractView: InputFlowDelegate {
    func textChanged(_ newText: String) {
        viewModel.trigger(.keyChanged(newText))
    }
}

struct AddContractView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
                AddContractView(viewModel: AddContractViewModel(dependencies: dependencies).eraseToAnyViewModel())
        }
    }
}
