//
//  Button+Theme.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/16/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import Foundation
import SwiftUI

struct DefaultButtonStyle: ButtonStyle {
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        DefaultButton(configuration: configuration)
    }

    struct DefaultButton: View {
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        var body: some View {
            configuration.label
                .theme.font(.titleSmall)
                .foregroundColor(Color.white)
                .padding([.top, .bottom], 12)
                .padding([.leading, .trailing], 34)
                .background(isEnabled ? Color(Color.theme.blue.color) : Color(Color.theme.gray.color))
                .cornerRadius(24)
        }
    }
}

extension Theme {
    
    enum ButtonStyle {
        case `default`
    }

    /// Sets the style for `Button` within the environment of `self`.
    func buttonStyle(_ style: ButtonStyle) -> some View {
        switch style {
        case .default:
            return base.buttonStyle(DefaultButtonStyle())
        }
    }
}
