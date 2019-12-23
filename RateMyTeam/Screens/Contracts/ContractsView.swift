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
                VStack {
                    List {
                        Section(header: Text("CURRENT")) {
                            ForEach(viewModel.state.contracts) { contract in
                                ContractRow(contract: contract)
                            }
                        }
                        Section(header: Text("PAST")) {
                            ForEach(viewModel.state.pastContracts) { contract in
                                ContractRow(contract: contract)
                            }
                        }
                    }
                    Button(action: {
                        
                    }) {
                        Text("Delete account")
                    }
                    Spacer()
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
            .padding(.bottom, 40)
            .background(Color(Color.theme.background.color))
            .edgesIgnoringSafeArea(.bottom)
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
