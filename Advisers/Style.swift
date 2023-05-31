//
//  Styles.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/09.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
public typealias NativeColor = UIColor
public typealias NativeFont = UIFont
#elseif canImport(AppKit)
import AppKit
public typealias NativeColor = NSColor
public typealias NativeFont = NSFont
#endif

import MarkdownUI

extension Color {
    
    static let roomBG = Color("RoomBgColor")
    
    static let messageHoverBG = Color("MessageHoverBgColor")
    
    init(nativeColor: NativeColor) {
        self.init(cgColor: nativeColor.cgColor)
    }
}

extension NativeColor {
    var rgbaComponents: (red: Double, green: Double, blue: Double, alpha: Double)? {
        guard let color = usingColorSpace(.sRGB) else { return nil }
        return (Double(color.redComponent), Double(color.greenComponent), Double(color.blueComponent), Double(color.alphaComponent))
    }

    convenience init(red: Double, green: Double, blue: Double, alpha: Double) {
        self.init(srgbRed: CGFloat(red),
                  green: CGFloat(green),
                  blue: CGFloat(blue),
                  alpha: CGFloat(alpha))
    }
}

extension NativeFont {
    class func preferredFont(from font: Font) -> NativeFont {
        let nativeFont: NativeFont
        
        switch font {
        case .largeTitle:
            nativeFont = NativeFont.preferredFont(forTextStyle: .largeTitle)
        case .title:
            nativeFont = NativeFont.preferredFont(forTextStyle: .title1)
        case .title2:
            nativeFont = NativeFont.preferredFont(forTextStyle: .title2)
        case .title3:
            nativeFont = NativeFont.preferredFont(forTextStyle: .title3)
        case .headline:
            nativeFont = NativeFont.preferredFont(forTextStyle: .headline)
        case .subheadline:
            nativeFont = NativeFont.preferredFont(forTextStyle: .subheadline)
        case .callout:
            nativeFont = NativeFont.preferredFont(forTextStyle: .callout)
        case .caption:
            nativeFont = NativeFont.preferredFont(forTextStyle: .caption1)
        case .caption2:
            nativeFont = NativeFont.preferredFont(forTextStyle: .caption2)
        case .footnote:
            nativeFont = NativeFont.preferredFont(forTextStyle: .footnote)
        case .body:
            fallthrough
        default:
            nativeFont = NativeFont.preferredFont(forTextStyle: .body)
        }
        
        return nativeFont
    }
}


struct AppButtonStyle: ButtonStyle {
    var foregroundColor: Color
    var pressedForegroundColor: Color
    var backgroundColor: Color
    var pressedBackgroundColor: Color
    
    @Environment(\.isEnabled) private var isEnabled: Bool

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .foregroundColor(configuration.isPressed ? pressedForegroundColor : foregroundColor)
            .background(configuration.isPressed ? pressedBackgroundColor : backgroundColor)
            .opacity(isEnabled ? 1.0 : 0.6)
            .cornerRadius(6)
    }
}

extension AppButtonStyle {
    static let closeButton = AppButtonStyle(
        foregroundColor: .primary,
        pressedForegroundColor: .primary.opacity(0.6),
        backgroundColor: .gray.opacity(0.2),
        pressedBackgroundColor: .gray.opacity(0.1)
    )
}

extension Theme {
  private static let messageRowBase = Theme()
    .code {
        FontFamilyVariant(.monospaced)
        FontSize(.em(0.85))
    }
    .paragraph { configuration in
        configuration.label
            .relativeLineSpacing(.em(0.25))
            .markdownMargin(top: 0, bottom: 16)
    }
    .listItem { configuration in
        configuration.label
            .markdownMargin(top: .em(0.25))
    }
    
    static let messageRowDark = messageRowBase
        .codeBlock { configuration in
            configuration.label
                .markdownMargin(top: .em(0), bottom: .em(1))
                .monospaced()
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(.white.opacity(0.05))
                .cornerRadius(2)
        }
    
    static let messageRowLight = messageRowBase
        .codeBlock { configuration in
            configuration.label
                .markdownMargin(top: .em(0), bottom: .em(1))
                .monospaced()
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(.black.opacity(0.05))
                .cornerRadius(2)
        }
}
