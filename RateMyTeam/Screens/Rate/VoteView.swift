//
//  VoteView.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/13/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import SwiftUI

struct VoteView: View {
    let candidate: Candidate
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text(candidate.name)
                    Text(candidate.address)
                }
                Button(action: {
                    
                }) {
                    Image(Asset.cancel.name)
                }
            }
            .background(Color(Color.theme.background.color))
        }
    }
}

#if DEBUG
struct VoteView_Previews: PreviewProvider {
    static var previews: some View {
        VoteView(candidate: Candidate.preview())
    }
}
#endif
