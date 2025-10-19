//
//  AppNavigator.swift
//  CartApp
//
//  Created by Kacper Wysocki on 15/10/2025.
//

import Foundation
import UIKit

class AppNavigator: BaseNavigator {
    static let shared = AppNavigator()

    var oldRoot: UINavigationController?
    
    var mainTabBarRoot: UINavigationController?
    var barItemRoot: UINavigationController?
    
    func setRoot(viewController: UINavigationController) {
        rootViewController = viewController
    }
    
    func saveOldRoot() {
        oldRoot = rootViewController
    }
    
    func restoreOldRoot() {
        rootViewController = oldRoot
    }
    
    init() {
        super.init(with: MainRoutes.splash)
    }
    
    required init(with route: Route) {
        super.init(with: route)
    }
}
