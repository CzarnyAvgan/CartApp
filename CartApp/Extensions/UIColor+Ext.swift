//
//  UIColor+Ext.swift
//  CartApp
//
//  Created by Kacper Wysocki on 15/10/2025.
//

import Foundation
import UIKit

extension UIColor {
    static public let appOrange = UIColor(red: 240, green: 66, blue: 26)
    static public let superLightOrange = UIColor(red: 249, green: 153, blue: 89)
    static public let appWhite = UIColor(red: 255, green: 255, blue: 255)
    static public let backgroundGrey = UIColor(red: 121, green: 121, blue: 121)
    static public let appBlack = UIColor(red: 0, green: 0, blue: 0)
    static public let beige = UIColor(red: 251, green: 241, blue: 235)
    static public let superLightGreen = UIColor(red: 178, green: 203, blue: 198)
    static public let lightOrange = UIColor(red: 255, green: 176, blue: 23)
    static public let lightRed = UIColor(red: 245, green: 122, blue: 84)


    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255

        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }

    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255

        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: a)
    }

    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }

    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0

        return NSString(format:"#%06x", rgb) as String
    }
}
