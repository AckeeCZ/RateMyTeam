//
//  ContractsView.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/6/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import Foundation
import SwiftUI
import class UIKit.UITableView

struct ContractsView: View {
    @ObservedObject var viewModel: AnyViewModel<ContractsState, ContractsInput>
    
    init(viewModel: AnyViewModel<ContractsState, ContractsInput>) {
        UITableView.appearance().separatorStyle = .none
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("CURRENT")) {
                    ForEach(viewModel.state.contracts) { contract in
                        ContractRow(contract: contract)
                    }
                }
                Section(header: Text("PAST")) {
                    ForEach(viewModel.state.contracts) { contract in
                        ContractRow(contract: contract)
                    }
                }
            }
            .background(Color(Color.theme.background.color))
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Contracts")
        }
    }
}

struct ContractRow: View {
    let contract: ContractsState.ContractData
    
    var body: some View {
        ZStack {
            HStack {
                HStack {
                    Text(contract.contract.id)
                        .theme.font(.bodyLarge)
                        .scaledToFill()
                        .padding([.leading, .top, .bottom], 20)
                }
                NavigationLink(destination: RateView(viewModel: contract.viewModel)) {
                    EmptyView()
                }
                Image(Asset.arrowRight.name)
                    .padding(.trailing, 20)
            }
            .background(Color.white)
            .cornerRadius(6)
            .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 0)
        }
        .listRowBackground(Color(Color.theme.background.color))
    }
}
