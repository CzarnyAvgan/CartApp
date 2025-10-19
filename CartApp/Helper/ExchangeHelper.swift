//
//  ExchangeHelper.swift
//  CartApp
//
//  Created by Kacper Wysocki on 15/10/2025.
//

import Foundation

struct ExchangeHelper {
    static let shared = ExchangeHelper()
    
    private static var rates: [String: Double] = [:]
    private static var baseCurrency: String = ""
    
    static func configureExchange(response: ExchangeResponse) {
        self.rates = response.quotes
        self.baseCurrency = response.source
    }
    
    func convert(amount: Double, from: String, to: String) -> Double? {
        guard amount >= 0 else { return nil }
        if from == to { return amount }
        
        guard let fromRate = rate(for: from),
              let toRate = rate(for: to),
              fromRate > 0 else { return nil }
        
        if from == Self.baseCurrency {
            return amount * toRate
        }
        
        if to == Self.baseCurrency {
            return amount / fromRate
        }
        
        return (amount / fromRate) * toRate
    }
    
    private func rate(for currency: String) -> Double? {
        if currency == Self.baseCurrency { return 1.0 }
        return Self.rates["\(Self.baseCurrency)\(currency)"]
    }
}
