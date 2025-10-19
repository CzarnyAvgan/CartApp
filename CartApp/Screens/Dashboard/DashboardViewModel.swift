//
//  DashboardViewModel.swift
//  CartApp
//
//  Created by Kacper Wysocki on 15/10/2025.
//

import Foundation
import RxSwift
import RxCocoa

class DashboardViewModel: BaseViewModel {
    
    private let productService = ProductService.shared
    let products = BehaviorRelay<[Product]>(value: [])
    
    func loadProducts() {
        state.accept(.loading)
        productService.getProductsMock()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] list in
                self?.products.accept(list)
                self?.state.accept(.idle)
            }, onError: { [weak self] error in
                self?.state.accept(.error(error.localizedDescription))
            })
            .disposed(by: disposeBag)
    }
}
