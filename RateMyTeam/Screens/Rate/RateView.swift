//
//  RateView.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/2/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import Foundation
import SwiftUI
import TezosSwift
import Combine

struct RateView: View {
    @ObservedObject var viewModel: AnyViewModel<RateState, RateInput>
    
    var body: some View {
        HStack {
            VStack {
                InfoView(info: [
                    InfoView.Info(title: "Open since", text: "21.9.2019"),
                    InfoView.Info(title: "Voted count", text: "10"),
                    InfoView.Info(title: "Votes left", text: "162/180")
                ])
                .padding([.leading, .trailing], 15)
                List(viewModel.state.candidates) {
                    Text($0.id)
                }
            }
            Spacer()
        }
        .navigationBarTitle(Text(verbatim: viewModel.state.title), displayMode: .inline)
    }
}

#if DEBUG
struct RateView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RateView(viewModel: RateViewModel(rateContract: RateContractStorage.preview(),
                                              dependencies: dependencies).eraseToAnyViewModel())
        }
    }
}
#endif
