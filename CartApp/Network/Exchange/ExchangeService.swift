//
//  ExchangeService.swift
//  CartApp
//
//  Created by Kacper Wysocki on 15/10/2025.
//

import Foundation
import Moya

class ExchangeService: MoyaProvider<ExchangeResource> {
    static let shared = ExchangeService()
    
    func getExchanges(completion: ((ExchangeResponse?, Error?) -> Void)?) {
        request(.getExchanges) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedValue = try response.map(ExchangeResponse.self)
                    completion?(decodedValue, nil)
                } catch {
                    completion?(nil, error)
                }
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }
    
    func getExchangesMock(completion: ((ExchangeResponse?, Error?) -> Void)?) {
        let fileName = "mockExchangeResponse"
        let fileExtension = "json"
        let fileService = FileResourceService()
        do {
            let data = try fileService.loadDataFromBundle(fileName: fileName, fileExtension: fileExtension)
            let decoded: ExchangeResponse = try fileService.decodeExchangeResponse(from: data)
            completion?(decoded, nil)
        } catch {
            completion?(nil, error)
        }
    }
}
