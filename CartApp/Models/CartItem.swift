//
//  CartItem.swift
//  CartApp
//
//  Created by Kacper Wysocki on 19/10/2025.
//


import Foundation

struct CartItem: Identifiable, Codable, Equatable {
    
    let id: Int
    let product: Product
    var quantity: Int
    
    var totalPrice: Double {
        return product.price * Double(quantity)
    }

    static func == (lhs: CartItem, rhs: CartItem) -> Bool {
        return lhs.id == rhs.id
            && lhs.product.id == rhs.product.id
            && lhs.quantity == rhs.quantity
    }
}
