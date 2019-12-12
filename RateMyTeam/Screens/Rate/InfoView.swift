//
//  InfoView.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/12/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import SwiftUI

struct InfoView: View {
    struct Info: Identifiable {
        var id: String {
            title
        }
        let title: String
        let text: String
    }
    
    let info: [Info]
    var body: some View {
        VStack(spacing: 8) {
            ForEach(info) { info in
                HStack {
                    Text(info.title)
                    Spacer()
                    Text(info.text)
                }
            }
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(info: [
            InfoView.Info(title: "Open since", text: "21.9.2019"),
            InfoView.Info(title: "Open since", text: "21.9.2019")
        ])
    }
}
