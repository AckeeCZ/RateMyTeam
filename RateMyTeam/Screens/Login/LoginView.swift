//
//  LoginView.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/16/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import SwiftUI

struct InputView: View {
    @Binding var text: String
    var body: some View {
        VStack {
            HStack {
                ZStack(alignment: .leading) {
                    if text.isEmpty { Text("Enter your key").foregroundColor(.white) }
                    TextField("", text: $text)
                        .foregroundColor(.white)
                }
                
                Button(action: {
                    
                }) {
                    Text("PASTE")
                        .theme.font(.sectionTitle)
                        .foregroundColor(Color.white)
                        .opacity(0.4)
                }
                Image(Asset.paste.name)
            }
            HStack {
                Color.white.frame(height: 2)
            }
        }
    }
}

struct LoginView: View {
    @State var text: String = ""
    var body: some View {
        VStack(alignment: .leading, spacing: 38) {
            Spacer()
            HStack {
                Spacer()
                Image(Asset.loginTitleIcon.name)
                Spacer()
            }
            InputView(text: $text)
            Button(action: {
                
            }) {
                Text("Enter")
            }
            .theme.buttonStyle(.inverseDefault)
            Spacer()
        }
        .padding([.leading, .trailing], 42)
        .background(Image(Asset.loginBackground.name)
        .resizable()
        .scaledToFill()
        .background(Color(Color.theme.blue.color)))
        .edgesIgnoringSafeArea(.all)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
