//
//  MainRoutes.swift
//  CartApp
//
//  Created by Kacper Wysocki on 15/10/2025.
//

import Foundation
import UIKit

enum MainRoutes: Route {
    case splash
    case dashboard
    case cart
    
    var screen: UIViewController {
        switch self {
        case .splash:
            return buildSplashViewController()
        case .dashboard:
            return buildDashboardViewController()
        case .cart:
            return buildCartViewController()
        }
    }
    
    private func buildSplashViewController() -> UIViewController {
        let controller = SplashViewController()
        return controller
    }
        
    private func buildDashboardViewController() -> UIViewController {
        let controller = DashboardViewController()
        let vm = DashboardViewModel()
        controller.viewModel = vm
        return controller
    }
    
    private func buildCartViewController() -> UIViewController {
        let controller = CartViewController()
        let vm = CartViewModel()
        controller.viewModel = vm
        return controller
    }
}
