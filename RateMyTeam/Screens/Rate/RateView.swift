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
    @State var showVoteView: Bool = false
    @State var selectedCandidate: Candidate?
    
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
                        ForEach(viewModel.state.candidates) { candidate in
                            Button(action: {
                                withAnimation(.easeInOut) {
                                    self.selectedCandidate = candidate
                                    self.showVoteView.toggle()
                                }
                            }) {
                                CandidateRow(candidate: candidate)
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
                voteView(for: selectedCandidate)
                    .transition(.move(edge: .bottom))
            }
        }
        .background(Color(Color.theme.background.color))
        .navigationBarTitle(Text(verbatim: viewModel.state.title), displayMode: .inline)
    }
    
    private func voteView(for candidate: Candidate?) -> AnyView {
        guard let candidate = candidate else { return AnyView(EmptyView()) }
        return AnyView(VoteView(candidate: candidate,
                                viewModel: viewModel.state.voteViewModel,
                                isPresented: $showVoteView,
                                votesCountChanged: {
                                    self.viewModel.trigger(.votesCountChanged(candidate: candidate, count: $0))
                                }))
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
