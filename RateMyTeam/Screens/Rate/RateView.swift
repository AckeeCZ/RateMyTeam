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
                    InfoView.Info(title: "Voted count", text: String(viewModel.state.totalNumberOfVotes) + "/" + String(viewModel.state.maximumNumberOfVotes)),
                    InfoView.Info(title: "My votes left", text: String(viewModel.state.votesLeft) + "/" + String(viewModel.state.votesPerVoter))
                ])
                .background(Color.clear)
                .padding([.leading, .trailing], 15)
                List {
                    ForEach(viewModel.state.candidates) {
                        CandidateRow(candidate: $0)
                            .listRowBackground(Color(Color.theme.background.color))
                    }
                }.listRowBackground(Color.red)
            }.padding(.top, 38)
            Spacer()
        }
        .background(Color(Color.theme.background.color))
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
