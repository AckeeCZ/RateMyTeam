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
    let activeColor: Color
    let inactiveColor: Color
    let foregroundColor: Color
    
    struct DefaultButtonStyleConfiguration {
        let label: ButtonStyleConfiguration.Label
    }
    
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        DefaultButton(configuration: configuration,
                      activeColor: activeColor,
                      inactiveColor: inactiveColor,
                      foregroundColor: foregroundColor)
    }

    struct DefaultButton: View {
        let configuration: ButtonStyle.Configuration
        let activeColor: Color
        let inactiveColor: Color
        let foregroundColor: Color
        
        @Environment(\.isEnabled) private var isEnabled: Bool
        var body: some View {
            configuration.label
                .theme.font(.titleSmall)
                .foregroundColor(foregroundColor)
                .padding([.top, .bottom], 12)
                .padding([.leading, .trailing], 34)
                .background(isEnabled ? activeColor : inactiveColor)
                .cornerRadius(24)
        }
    }
}

extension Theme {
    
    enum ButtonStyle {
        case `default`
        case inverseDefault
    }

    /// Sets the style for `Button` within the environment of `self`.
    func buttonStyle(_ style: ButtonStyle) -> some View {
        switch style {
        case .default:
            return base.buttonStyle(DefaultButtonStyle(activeColor: Color(Color.theme.blue.color),
                                                       inactiveColor: Color(Color.theme.gray.color),
                                                       foregroundColor: Color.white))
        case .inverseDefault:
            return base.buttonStyle(DefaultButtonStyle(activeColor: Color.white,
                                                       inactiveColor: Color.white,
                                                       foregroundColor: Color(Color.theme.blue.color)))
        }
    }
}
