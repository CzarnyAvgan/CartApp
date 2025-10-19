//
//  CartViewModel.swift
//  CartApp
//
//  Created by Kacper Wysocki on 19/10/2025.
//

import Foundation
import RxSwift
import RxCocoa

final class CartViewModel: BaseViewModel {
    private let exchangeService = ExchangeService.shared
    let cartItems = BehaviorRelay<[CartItem]>(value: [])
    let totalPrice = BehaviorRelay<Double>(value: 0.0)
    let selectedCurrency = BehaviorRelay<String>(value: "USD")
    let availableCurrencies: [String] = ["USD", "EUR", "GBP", "PLN"]
    
    override init() {
        super.init()
        CartManager.shared.items
            .bind(to: cartItems)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(CartManager.shared.items, selectedCurrency)
            .flatMapLatest { [weak self] items, currency -> Observable<Double> in
                guard let self = self else { return .just(0) }
                return self.fetchRatesIfNeeded()
                    .map { _ in
                        items.reduce(0.0) { partial, item in
                            let baseAmount = item.product.price
                            let from = item.product.currency
                            let qty = Double(item.quantity)
                            let converted = ExchangeHelper.shared.convert(amount: baseAmount, from: from, to: currency) ?? baseAmount
                            return partial + converted * qty
                        }
                    }
            }
            .bind(to: totalPrice)
            .disposed(by: disposeBag)
    }
    
    func clearCart() {
        CartManager.shared.clear()
    }
    
    func removeItem(_ product: Product) {
        CartManager.shared.removeFromCart(product)
    }
    func addItem(_ product: Product) {
        CartManager.shared.addToCart(product)
    }
    
    func convertCart(to targetCurrency: String) {
        selectedCurrency.accept(targetCurrency)
    }
    
    private func fetchRatesIfNeeded() -> Observable<Void> {
        return Observable<Void>.create { observer in
            self.exchangeService.getExchangesMock {response, _ in
                if let response = response {
                    ExchangeHelper.configureExchange(response: response)
                }
                observer.onNext(())
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}

