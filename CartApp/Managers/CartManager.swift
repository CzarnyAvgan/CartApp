//
//  CartManager.swift
//  CartApp
//
//  Created by Kacper Wysocki on 19/10/2025.
//


import Foundation
import RxSwift
import RxCocoa

final class CartManager {
    static let shared = CartManager()
    
    let items = BehaviorRelay<[CartItem]>(value: [])
    let totalPrice = BehaviorRelay<Double>(value: 0.0)
    
    private init() {}
    
    func addToCart(_ product: Product) {
        var cart = items.value
        if let index = cart.firstIndex(where: { $0.product.id == product.id }) {
            cart[index].quantity += 1
        } else {
            cart.append(CartItem(id: product.id, product: product, quantity: 1))
        }
        items.accept(cart)
        recalcTotal()
    }
    
    func removeFromCart(_ product: Product) {
        var cart = items.value
        if let index = cart.firstIndex(where: { $0.product.id == product.id }) {
            if cart[index].quantity > 1 {
                cart[index].quantity -= 1
            } else {
                cart.remove(at: index)
            }
        }
        items.accept(cart)
        recalcTotal()
    }
    
    func recalcTotal() {
        let total = items.value.reduce(0) { $0 + $1.totalPrice }
        totalPrice.accept(total)
    }
    
    func clear() {
        items.accept([])
        totalPrice.accept(0)
    }
}
