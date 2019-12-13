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

struct VoteView: View {
    var body: some View {
        Text("Voting").background(Color.white)
    }
}

struct RateView: View {
    @ObservedObject var viewModel: AnyViewModel<RateState, RateInput>
    @State var showVoteView: Bool = false
    
    var body: some View {
        ZStack {
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
                        Button(action: {
                            withAnimation(.easeInOut) {
                                self.showVoteView.toggle()
                            }
                        }) {
                            ForEach(viewModel.state.candidates) {
                                CandidateRow(candidate: $0)
                            }
                        }
                        .listRowBackground(Color(Color.theme.background.color))
                    }
                }.padding(.top, 38)
                Spacer()
            }
            .overlay(
                Color.black
                    .opacity(showVoteView ? 0.6 : 0.0)
                    .edgesIgnoringSafeArea([.top, .bottom])
            )
            
            if showVoteView {
                VoteView()
                    .transition(.move(edge: .bottom))
            }
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
