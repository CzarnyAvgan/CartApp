//
//  Product.swift
//  CartApp
//
//  Created by Kacper Wysocki on 19/10/2025.
//


struct Product: Codable, Identifiable {
    let id: Int
    let name: String
    let price: Double
    let currency: String
    let unit: String
    let imageUrl: String
}