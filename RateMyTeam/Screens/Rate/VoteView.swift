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
    @Binding var isPresented: Bool
    @State private var votesSelected: Int = 0
    
    var body: some View {
        VStack(spacing: 30) {
            HStack(alignment: .top, spacing: 10) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(candidate.name)
                        .foregroundColor(Color(Color.theme.textBlack.color))
                        .theme.font(.body)
                    Text(candidate.address)
                        .theme.font(.bodySmall)
                        .foregroundColor(Color(Color.theme.textBlack.color))
                        .opacity(0.4)
                }
                Button(action: {
                    withAnimation(.easeInOut) {
                        self.isPresented = false
                    }
                }) {
                    Image(Asset.cancel.name)
                }
            }
            .padding([.top, .bottom, .leading], 16)
            .padding(.trailing, 8)
            .background(Color(Color.theme.background.color))
            .cornerRadius(6)
                        
            VStack(spacing: 12) {
                Text(String(3))
                    .theme.font(.titleLarge)
                    .foregroundColor(Color.white)
                    .frame(width: 62, height: 62)
                    .background(Color(Color.theme.pink.color))
                    .cornerRadius(31)
             
                Stepper(onIncrement: {
                    guard self.votesSelected != 10 else { return }
                    self.votesSelected += 1
                }, onDecrement: {
                    guard self.votesSelected != 0 else { return }
                    self.votesSelected -= 1
                }) {
                    EmptyView()
                }
                .fixedSize()
                .padding(.trailing, 8)
            }
            
            Button(action: {
                withAnimation(.easeInOut) {
                    self.isPresented = false
                }
            }) {
                Text("Confirm")
                    .theme.font(.titleSmall)
                    .foregroundColor(Color.white)
                    .padding([.top, .bottom], 16)
                    .padding([.leading, .trailing], 40)
                    .background(Color(Color.theme.blue.color))
                    .cornerRadius(24)
            }
            .padding(.bottom, 16)
        }
        .background(Color.white)
        .cornerRadius(6)
    }
}

#if DEBUG
struct VoteView_Previews: PreviewProvider {
    static var previews: some View {
        VoteView(candidate: Candidate.preview(), isPresented: .constant(false))
    }
}
#endif
