//
//  ContractsRow.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/12/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import Foundation
import SwiftUI

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

struct ContractRow_Previews: PreviewProvider {
    static var previews: some View {
        ContractRow(contract:
            ContractsState.ContractData(contract: RateContractStorage(id: "KT098098dsf98908",
                                                                      candidates: [
                                                                        Candidate(id: "KT9889899SSi",
                                                                                  numberOfVotes: 2)]),
                                        viewModel: RateViewModel(rateContract:
                                            RateContractStorage(id: "KT098098dsf98908",
                                                                candidates: [
                                                                Candidate(id: "KT9889899SSi",
                                                                          numberOfVotes: 2)]),
                                      dependencies: dependencies).eraseToAnyViewModel()))
    }
}
