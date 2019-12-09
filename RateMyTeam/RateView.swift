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
        List(viewModel.state.candidates) {
            Text($0.id)
        }
        .navigationBarTitle(Text(verbatim: viewModel.state.title), displayMode: .inline)
    }
}

struct RateContract: Identifiable {
    let id: String
    let candidates: [Candidate]
}

extension Publisher {
    func startAndStore(in set: inout Set<AnyCancellable>) {
        sink(receiveCompletion: { _ in }, receiveValue: { _ in })
        .store(in: &set)
    }
}

struct Candidate: Identifiable {
    /// Address
    let id: String
    let numberOfVotes: Int
}
