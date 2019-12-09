//
//  Theme.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/9/19.
//  Copyright © 2019 Marek Fořt. All rights reserved.
//

import Foundation
import SwiftUI

struct ScaledFont: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory
    let name: String
    let size: CGFloat

    func body(content: Content) -> some View {
       let scaledSize = UIFontMetrics.default.scaledValue(for: size)
        return content.font(.custom(name, size: scaledSize))
    }
}

struct Theme<Base: View> {
    private let base: Base
    
    init(_ base: Base) {
        self.base = base
    }
    
    func font(_ font: Theme.Font) -> some View {
        let fontProperties = Theme.font(font)
        return base.modifier(ScaledFont(name: fontProperties.name, size: fontProperties.size))
    }
}

extension View {
    func scaledFont(name: String, size: CGFloat) -> some View {
        return self.modifier(ScaledFont(name: name, size: size))
    }
    
    var theme: Theme<Self> {
        Theme<Self>(self)
    }
}

extension View {
    
}

// Load fonts when first used from bundle root directory
private final class BundleLocator {}
private let fonts: [URL] = {
    // swiftlint:disable:next force_unwrapping
    let bundleURL = Bundle(for: BundleLocator.self).resourceURL!
    let resourceURLs = try? FileManager.default.contentsOfDirectory(at: bundleURL, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
    let fonts = resourceURLs?.filter { $0.pathExtension == "otf" || $0.pathExtension == "ttf" } ?? []

    fonts.forEach { CTFontManagerRegisterFontsForURL($0 as CFURL, CTFontManagerScope.process, nil) }

    return fonts
}()

extension Theme {
    typealias FontProperties = (name: String, size: CGFloat)
    
    enum Font {
        case regular(CGFloat)
        case bodyLarge
    }
    
    fileprivate static func font(_ font: Font) -> FontProperties {
        switch font {
        case let .regular(size):
            return (name: "Roboto-Regular", size: size)
        case .bodyLarge:
            return Theme.font(.regular(16))
        }
    }
}
