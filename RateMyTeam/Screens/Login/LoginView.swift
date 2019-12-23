//
//  LoginView.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/16/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AnyViewModel<LoginState, LoginInput>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 38) {
            Spacer()
            HStack {
                Spacer()
                Image(Asset.loginTitleIcon.name)
                Spacer()
            }
            InputView(viewModel: viewModel.state.inputViewModel,
                      delegate: self,
                      textColor: .white,
                      themeColor: .white,
                      pasteColor: .black)
            Button(action: {
                self.viewModel.trigger(.enter)
            }) {
                Text("Enter")
            }
            .theme.buttonStyle(.inverseDefault)
            Spacer()
        }
        .padding([.leading, .trailing], 42)
        .background(Image(Asset.loginBackground.name)
        .resizable()
        .scaledToFill()
        .background(Color(Color.theme.blue.color)))
        .edgesIgnoringSafeArea(.all)
    }
}

extension LoginView: InputFlowDelegate {
    func textChanged(_ newText: String) {
        viewModel.trigger(.keyChanged(newText))
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel(dependencies: dependencies).eraseToAnyViewModel())
    }
}
