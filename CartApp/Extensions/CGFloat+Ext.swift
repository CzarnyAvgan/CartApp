//
//  CGFloat+Ext.swift
//  CartApp
//
//  Created by Kacper Wysocki on 15/10/2025.
//

import Foundation
import UIKit

extension CGFloat {
    static var points:[Int:CGFloat] = [:]
    
    static public func configurePoints() {
        for index in 1...800 {
            points[index] = scaleToDevice(val: CGFloat(index))
        }
    }
    
    static public func pt(_ pt:CGFloat) -> CGFloat {
        return points[Int(pt)] ?? 0
    }
    
    static public func isSmallDevice() -> Bool {
        return UIScreen.main.bounds.height <= 667
    }
    
    static public func deviceScale() -> CGFloat {
        let factor = CGFloat(isSmallDevice() ? 450.0 : 414.0)
        return UIScreen.main.bounds.width/factor
    }
    
    static public func scaleToDevice(val: CGFloat) -> CGFloat {
        return Foundation.floor(val * deviceScale())
    }
}
