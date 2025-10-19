//
//  File.swift
//  CartApp
//
//  Created by Kacper Wysocki on 15/10/2025.
//

import UIKit

extension UIFont {
    private static var currentFontScale: CGFloat = 1.0
    private static let maxFontScale: CGFloat = 1.80
    
    private static func accessibilityFontScale() -> CGFloat {
        let font = UIFont.preferredFont(forTextStyle: .body)
        return min(self.maxFontScale,(font.pointSize/17.0))
    }

    static public func configureStyles() {
        self.currentFontScale = self.accessibilityFontScale()
    }

    static public func scaledFont(val: CGFloat, limit: CGFloat? = nil) -> CGFloat {
        if val > 50 {
            return floor(val * CGFloat.deviceScale())
        }
        if let limit = limit {
            return floor(min(limit * CGFloat.deviceScale(), val * CGFloat.deviceScale() * self.currentFontScale))
        }
        return floor(val * CGFloat.deviceScale() * self.currentFontScale)
    }
    
    static public func poppinsRegular(size: CGFloat, scaled: Bool = true) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: scaled ? scaledFont(val: size) : size)!
    }
    
    static public func poppinsBold(size: CGFloat, scaled: Bool = true) -> UIFont {
        return UIFont(name: "Poppins-Bold", size: scaled ? scaledFont(val: size) : size)!
    }
    
    static public func poppinsSemiBold(size: CGFloat, scaled: Bool = true) -> UIFont {
        return UIFont(name: "Poppins-SemiBold", size: scaled ? scaledFont(val: size) : size)!
    }
}

