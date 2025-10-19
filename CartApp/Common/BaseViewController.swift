//
//  BaseViewController.swift
//  CartApp
//
//  Created by Kacper Wysocki on 15/10/2025.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class BaseViewController<T: BaseViewModel>: UIViewController {
    let disposeBag = DisposeBag()
    var viewModel: T!
    
    private var cartButton = UIButton(type: .custom)
    private var badgeLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        bindToViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        configureNavigationBarBackButton()
    }
    
    func setupViews() {
        view.setGradientBackground(colorOne: .superLightOrange, colorTwo: .appWhite)
    }
    
    func setupConstraints() {}
    
    func bindToViewModel() {}
    
    func configureNavigationBarBackButton(buttonColor: UIColor? = .appBlack, image: UIImage = .backButton, showCartButton: Bool = true) {
        let item = UIBarButtonItem(image: image.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(backButtonAction))
        item.tintColor = buttonColor
        item.imageInsets = UIEdgeInsets(top: .pt(4), left: 0, bottom: 0, right: 0)
        navigationItem.setLeftBarButton(item, animated: true)
        
        if showCartButton {
            setupCartButton()
        }
    }
    
    func removeCustomBackButton() {
        let item = UIBarButtonItem()
        navigationItem.setLeftBarButton(item, animated: false)
    }
    
    @objc func backButtonAction() {
        AppNavigator.shared.pop()
    }
    
    private func setupCartButton() {
        cartButton = UIButton(type: .custom)
        let cartImage = UIImage(systemName: "cart.fill")?.withRenderingMode(.alwaysTemplate)
        cartButton.setImage(cartImage, for: .normal)
        cartButton.tintColor = .systemOrange
        cartButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        
        badgeLabel = UILabel()
        badgeLabel.backgroundColor = .systemRed
        badgeLabel.textColor = .white
        badgeLabel.font = .systemFont(ofSize: 11, weight: .bold)
        badgeLabel.textAlignment = .center
        badgeLabel.layer.cornerRadius = 9
        badgeLabel.layer.masksToBounds = true
        badgeLabel.isHidden = true
        badgeLabel.layer.borderWidth = 1
        badgeLabel.layer.borderColor = UIColor.white.cgColor
        
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        cartButton.addSubview(badgeLabel)
        NSLayoutConstraint.activate([
            badgeLabel.topAnchor.constraint(equalTo: cartButton.topAnchor, constant: -2),
            badgeLabel.trailingAnchor.constraint(equalTo: cartButton.trailingAnchor, constant: 2),
            badgeLabel.heightAnchor.constraint(equalToConstant: 18),
            badgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 18)
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cartButton)
        
        CartManager.shared.items
            .map { $0.reduce(0) { $0 + $1.quantity } }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] count in
                guard let self = self else { return }
                if count > 0 {
                    self.badgeLabel.text = count > 99 ? "99+" : "\(count)"
                    self.badgeLabel.isHidden = false
                    self.animateBadge()
                } else {
                    self.badgeLabel.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        cartButton.addTarget(self, action: #selector(openCart), for: .touchUpInside)
    }

    private func animateBadge() {
        badgeLabel.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseOut,
                       animations: {
            self.badgeLabel.transform = .identity
        })
    }
    
    @objc private func openCart() {
        AppNavigator.shared.navigate(to: MainRoutes.cart, with: .push)
    }
}
