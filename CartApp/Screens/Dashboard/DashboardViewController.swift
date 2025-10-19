//
//  DashboardViewController.swift
//  CartApp
//
//  Created by Kacper Wysocki on 15/10/2025.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class DashboardViewController: BaseViewController<DashboardViewModel> {
    
    private let tableView = UITableView()
    
    override func setupViews() {
        super.setupViews()
        title = "Products"
        
        tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.identifier)
        tableView.rowHeight = 110
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func bindToViewModel() {
        viewModel.products
            .bind(to: tableView.rx.items(cellIdentifier: ProductCell.identifier, cellType: ProductCell.self)) { _, product, cell in
                cell.configure(with: product)
                
                let currentCart = CartManager.shared.items.value
                let quantity = currentCart.first(where: { $0.product.id == product.id })?.quantity ?? 0
                cell.updateQuantity(quantity)
                
                cell.onAddTapped = {
                    CartManager.shared.addToCart(product)
                }
                
                cell.onRemoveTapped = {
                    CartManager.shared.removeFromCart(product)
                }
            }
            .disposed(by: disposeBag)
        
        CartManager.shared.items
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadProducts()
    }
}

