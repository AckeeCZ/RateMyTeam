//
//  Theme.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/9/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import Foundation
import SwiftUI

struct Theme<Base: View> {
    let base: Base
    
    init(_ base: Base) {
        self.base = base
    }
    
    func font(_ font: Theme.Font) -> some View {
        let fontProperties = Theme.font(font)
        return base.modifier(ScaledFont(name: fontProperties.name, size: fontProperties.size))
    }
}
extension View {    
    var theme: Theme<Self> {
        Theme<Self>(self)
    }
}
