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
            
            List(viewModel.state.contracts) { contract in
                NavigationLink(destination: RateView(viewModel: contract.viewModel)) {
                    ContractRow(contract: contract.contract)
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
