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
                                ContractRow(contract: contract, isActive: true)
                            }
                        }
                        Section(header: Text("PAST")) {
                            ForEach(viewModel.state.pastContracts) { contract in
                                ContractRow(contract: contract, isActive: false)
                            }
                        }
                    }
                    Text("My wallet address:\n\(viewModel.state.walletAddress)")
                        .theme.font(.bodySmall)
                        .foregroundColor(.black)
                        .opacity(0.4)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                .padding(.bottom, 20)
                
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
                .padding(.bottom, 40)
            }
            .listStyle(GroupedListStyle())
            .background(Color(Color.theme.background.color))
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarTitle("Voting", displayMode: .inline)
            .background(NavigationConfigurator { nc in
                nc.navigationBar.barTintColor = .blue
                nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(.white)
    }
}

struct ContratsView_Previews: PreviewProvider {
    static var previews: some View {
        ContractsView(viewModel: ContractsViewModel(dependencies: dependencies).eraseToAnyViewModel())
    }
}
