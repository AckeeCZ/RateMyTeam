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
            ZStack {
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
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(destination: AddContractView(viewModel: viewModel.state.addContractViewModel)) {
                            Image(Asset.plusButton.name)
                                .padding(.trailing, 16)
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .background(Color(Color.theme.background.color))
            .navigationBarTitle("Voting", displayMode: .inline)
            .background(NavigationConfigurator { nc in
                nc.navigationBar.barTintColor = .blue
                nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContratsView_Previews: PreviewProvider {
    static var previews: some View {
        ContractsView(viewModel: ContractsViewModel(dependencies: dependencies).eraseToAnyViewModel())
    }
}
