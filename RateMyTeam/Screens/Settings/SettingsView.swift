//
//  SettingsView.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 1/3/20.
//  Copyright © 2020 Marek Fořt. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var viewModel: AnyViewModel<SettingsState, SettingsInput>
    
    var body: some View {
        VStack(spacing: 20) {
            Text("My wallet address:\n\(viewModel.state.myWalletAddress)")
                .theme.font(.body)
                .foregroundColor(.black)
                .opacity(0.4)
                .multilineTextAlignment(.center)
            Button(action: {
                self.viewModel.trigger(.logout)
            }) {
                Text("Logout")
                    .theme.font(.titleSmall)
                    .foregroundColor(Color(Color.theme.blue.color))
            }
        }
        .navigationBarTitle("Voting", displayMode: .inline)
    }
}
