//
//  ExchangeResource.swift
//  CartApp
//
//  Created by Kacper Wysocki on 15/10/2025.
//

import Foundation
import Moya

enum ExchangeResource: TargetType {
    case getExchanges
    
    var baseURL: URL {
        switch self {
        case .getExchanges:
            return self.apiURL
        }
    }
    
    var path: String {
        switch self {
        case .getExchanges:
            return "/live"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getExchanges:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getExchanges:
            let parameters = getBaseParameters()
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
}
