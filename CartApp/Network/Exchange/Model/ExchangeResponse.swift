//
//  ExchangeResponse.swift
//  CartApp
//
//  Created by Kacper Wysocki on 15/10/2025.
//

import Foundation

struct ExchangeResponse: Codable {
    let success: Bool
    let timestamp: Date?
    let source: String
    let quotes: [String: Double]
}
