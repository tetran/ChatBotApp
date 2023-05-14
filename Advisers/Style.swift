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
#elseif canImport(AppKit)
import AppKit
public typealias NativeColor = NSColor
#endif

struct Style {
    
    static let roomBGColor = Color(CGColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1))
    
    static let messageHoverBGColor = Color(CGColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 1))
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
