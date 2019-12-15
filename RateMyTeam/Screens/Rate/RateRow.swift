//
//  RateRow.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/13/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import Foundation
import SwiftUI

struct CandidateRow: View {
    let candidate: Candidate
    
    var body: some View {
        ZStack {
            HStack(spacing: 16) {
                if candidate.numberOfVotes == 0 {
                    Image(Asset.question.name)
                        .frame(width: 42, height: 42)
                        .background(Color(Asset.Colors.background.color))
                        .cornerRadius(21)
                        .padding([.top, .bottom], 12)
                        .padding(.leading, 15)
                } else {
                    Text(String(candidate.numberOfVotes))
                        .frame(width: 42, height: 42)
                        .foregroundColor(Color.white)
                        .background(Color(Color.theme.pink.color))
                        .cornerRadius(21)
                        .padding([.top, .bottom], 12)
                        .padding(.leading, 15)
                }
                VStack(alignment: .leading, spacing: 6) {
                    Text(candidate.name)
                        .theme.font(.titleSmall)
                        .foregroundColor(Color(Color.theme.textBlack.color))
                    Text(candidate.address)
                        .theme.font(.bodySmall)
                        .foregroundColor(Color(Color.theme.textBlack.color))
                        .opacity(0.4)
                }
                .padding(.trailing, 8)
                Spacer()
            }
            .background(Color.white)
            .cornerRadius(6)
            .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 0)
        }
    }
}

struct CandidateRow_Previews: PreviewProvider {
    static var previews: some View {
        CandidateRow(candidate: Candidate(address: "tz9089809SDS9090S", numberOfVotes: 1, name: "Madonna"))
    }
}


