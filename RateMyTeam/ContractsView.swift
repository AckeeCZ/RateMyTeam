//
//  ContractsView.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/6/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import Foundation
import SwiftUI

enum ContractsInput {
    
}

struct ContractsState {
    var contracts: [RateContract]
}

struct ContractsView: View {
    @ObservedObject var viewModel: AnyViewModel<ContractsState, ContractsInput>
    
    var body: some View {
        NavigationView {
            List(viewModel.state.contracts) { contract in
                NavigationLink(destination: RateView(viewModel: RateViewModel(dependencies: dependencies).eraseToAnyViewModel())) {
                    ContractRow(contract: contract)
                }
            }
            .navigationBarTitle("Contracts")
        }
    }
}

struct ContractRow: View {
    let contract: RateContract
    
    var body: some View {
        Text(contract.id)
    }
}
