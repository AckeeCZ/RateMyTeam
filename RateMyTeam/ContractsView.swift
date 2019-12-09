//
//  ContractsView.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/6/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import Foundation
import SwiftUI

struct ContractsView: View {
    @ObservedObject var viewModel: AnyViewModel<ContractsState, ContractsInput>
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("CURRENT")) {
                    ForEach(viewModel.state.contracts) { contract in
                        HStack {
                            ContractRow(contract: contract.contract).scaledToFill()
                            NavigationLink(destination: RateView(viewModel: contract.viewModel)) {
                                EmptyView()
                            }
                            Image(Asset.arrowRight.name)
                        }
                    }.listRowBackground(Color(Color.theme.background.color))
                }
            }
            .background(Color(Color.theme.background.color))
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Contracts")
        }
    }
}

struct ContractRow: View {
    let contract: RateContract
    
    var body: some View {
        HStack {
            Text(contract.id).theme.font(.bodyLarge)
        }
    }
}
