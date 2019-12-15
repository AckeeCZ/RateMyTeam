//
//  Font+Theme.swift
//  RateMyTeam
//
//  Created by Marek Fořt on 12/13/19.
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

extension View {
    func scaledFont(name: String, size: CGFloat) -> some View {
        return self.modifier(ScaledFont(name: name, size: size))
    }
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
    struct FontProperties {
        let name: String
        let size: CGFloat
    }
    
    enum Font {
        case regular(size: CGFloat)
        case bold(size: CGFloat)
        case bodySmall
        case body
        case titleSmall
        case titleLarge
        case sectionTitle
    }
    
    static func font(_ font: Font) -> FontProperties {
        _ = fonts
        switch font {
        case let .regular(size: size):
            return FontProperties(name: "Roboto-Regular", size: size)
        case let .bold(size: size):
            return FontProperties(name: "Roboto-Bold", size: size)
        case .bodySmall:
            return Theme.font(.regular(size: 12))
        case .body:
            return Theme.font(.regular(size: 14))
        case .titleSmall:
            return Theme.font(.bold(size: 14))
        case .titleLarge:
            return Theme.font(.bold(size: 34))
        case .sectionTitle:
            return Theme.font(.bold(size: 10))
        }
    }
}

