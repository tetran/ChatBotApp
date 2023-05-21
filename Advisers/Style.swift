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

extension Color {
    
    static let roomBG = Color("RoomBgColor")
    
    static let messageHoverBG = Color("MessageHoverBgColor")
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
