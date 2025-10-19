//
//  ExchangeService.swift
//  CartApp
//
//  Created by Kacper Wysocki on 19/10/2025.
//


import Foundation
import Moya
import RxSwift
struct ProductService {
    static let shared = ProductService()
    
    func getProductsMock() -> Observable<[Product]> {
        let fileName = "mockProducts"
        let fileExtension = "json"
        let fileService = FileResourceService()
        return Observable.create { observer in
            do {
                let data = try fileService.loadDataFromBundle(fileName: fileName, fileExtension: fileExtension)
                let decoded: [Product] = try fileService.decodeExchangeResponse(from: data)
                observer.onNext(decoded)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
        
    }
}
