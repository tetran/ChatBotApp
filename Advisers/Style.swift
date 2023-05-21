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
