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
    let numberOfVotes: Int
    let hasNewVotes: Bool
    
    var body: some View {
        ZStack {
            HStack(spacing: 16) {
                if numberOfVotes == 0 {
                    Image(Asset.question.name)
                        .frame(width: 42, height: 42)
                        .background(Color(Asset.Colors.background.color))
                        .cornerRadius(21)
                        .padding([.top, .bottom], 12)
                        .padding(.leading, 15)
                } else {
                    Text(String(numberOfVotes))
                        .frame(width: 42, height: 42)
                        .foregroundColor(Color.white)
                        .background(hasNewVotes ? Color(Color.theme.pink.color) : Color.black)
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

#if DEBUG
struct CandidateRow_Previews: PreviewProvider {
    static var previews: some View {
        CandidateRow(candidate: Candidate.preview(), numberOfVotes: 1, hasNewVotes: true)
    }
}
#endif

