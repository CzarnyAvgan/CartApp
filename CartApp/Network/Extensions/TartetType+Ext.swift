//
//  TartetType+Ext.swift
//  CartApp
//
//  Created by Kacper Wysocki on 15/10/2025.
//

import Foundation
import Moya

enum HTTPHeader: String {
    case language = "Accept-Language"
    case accept = "Accept"
}

enum BaseParameter: String {
    case appKey = "app_key"
    case format = "format"
}

extension TargetType {
    var apiURL: URL {
        let baseApiString = (Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String) ?? ""
        return URL(string: baseApiString)!
    }
    
    var baseURL: URL {
        let baseApiString = (Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String) ?? ""
        return URL(string: baseApiString)!
    }
    
    var headers: [String: String]? {
        return getHeaders()
    }
}

extension TargetType {
    public func getHeaders() -> [String:String] {
        return [
            HTTPHeader.accept.rawValue: "application/json",
            HTTPHeader.language.rawValue: "en",
        ]
    }
    
    public func getBaseParameters() -> [String:String] {
        var parameters: [String:String] = [BaseParameter.format.rawValue : "1"]
        
        if let appKey = Bundle.main.object(forInfoDictionaryKey: "APP_KEY") as? String {
            parameters[BaseParameter.appKey.rawValue] = appKey
        }
        
        return parameters
    }
}

