//
//  CartViewController.swift
//  CartApp
//
//  Created by Kacper Wysocki on 19/10/2025.
//


import UIKit
import RxSwift
import RxCocoa
import Localize_Swift

final class CartViewController: BaseViewController<CartViewModel> {
    
    private let tableView = UITableView()
    private let totalLabel = UILabel()
    private let currencySelector = UISegmentedControl(items: ["USD", "EUR", "GBP", "PLN"])
    private let clearButton = UIButton(type: .system)
    private let emptyLabel = UILabel()
    
    override func configureNavigationBarBackButton(buttonColor: UIColor? = .appBlack, image: UIImage = .backButton, showCartButton: Bool = true) {
        super.configureNavigationBarBackButton(buttonColor: buttonColor, image: image, showCartButton: false)
    }
    
    override func setupViews() {
        super.setupViews()
        title = "cart_view_title".localized()
        
        tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.identifier)
        tableView.rowHeight = 110
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        totalLabel.font = .systemFont(ofSize: 18, weight: .bold)
        totalLabel.textAlignment = .center
        totalLabel.textColor = .label
        
        currencySelector.selectedSegmentIndex = 0
        currencySelector.selectedSegmentTintColor = .systemOrange
        currencySelector.backgroundColor = .systemGray6
        currencySelector.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        
        clearButton.setTitle("clear_cart_button_title".localized(), for: .normal)
        clearButton.tintColor = .systemRed
        clearButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        
        emptyLabel.text = "empty_cart_description".localized()
        emptyLabel.font = .systemFont(ofSize: 16, weight: .medium)
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .gray
        emptyLabel.isHidden = true
        
        [currencySelector, tableView, totalLabel, clearButton, emptyLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            currencySelector.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .pt(8)),
            currencySelector.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .pt(16)),
            currencySelector.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.pt(16)),
            
            tableView.topAnchor.constraint(equalTo: currencySelector.bottomAnchor, constant: .pt(8)),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: totalLabel.topAnchor, constant: -.pt(8)),
            
            totalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            totalLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            totalLabel.heightAnchor.constraint(equalToConstant: .pt(40)),
            
            clearButton.topAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: .pt(10)),
            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clearButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -.pt(10)),
            
            emptyLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            emptyLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor)
        ])
    }
    
    override func bindToViewModel() {
        viewModel.cartItems
            .bind(to: tableView.rx.items(cellIdentifier: ProductCell.identifier, cellType: ProductCell.self)) { _, item, cell in
                cell.configure(with: item.product)
                cell.updateQuantity(item.quantity)
                
                cell.onAddTapped = {
                    CartManager.shared.addToCart(item.product)
                }
                
                cell.onRemoveTapped = {
                    CartManager.shared.removeFromCart(item.product)
                }
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(viewModel.totalPrice, viewModel.selectedCurrency)
            .map { total, currency in
                String(format: "cart_total_format".localized(), total, currency)
            }
            .bind(to: totalLabel.rx.text)
            .disposed(by: disposeBag)
        
        currencySelector.rx.selectedSegmentIndex
            .map { self.viewModel.availableCurrencies[$0] }
            .subscribe(onNext: { [weak self] currency in
                self?.viewModel.convertCart(to: currency)
            })
            .disposed(by: disposeBag)
        
        clearButton.rx.tap
            .bind { [weak self] in
                self?.viewModel.clearCart()
            }
            .disposed(by: disposeBag)
        
        viewModel.cartItems
            .map { $0.isEmpty }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isEmpty in
                self?.emptyLabel.isHidden = !isEmpty
                self?.tableView.isHidden = isEmpty
                self?.currencySelector.isHidden = isEmpty
                self?.clearButton.isHidden = isEmpty
                self?.totalLabel.isHidden = isEmpty
            })
            .disposed(by: disposeBag)
        
        viewModel.state
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                switch state {
                case .loading:
                    self?.totalLabel.text = "cart_loading_text".localized()
                case .error(let msg):
                    self?.totalLabel.text = String(format: "cart_error_format".localized(), msg)
                case .idle:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        CartManager.shared.items
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

