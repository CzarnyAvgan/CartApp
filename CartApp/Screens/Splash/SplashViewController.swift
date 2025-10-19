//
//  SplashViewController.swift
//  CartApp
//
//  Created by Kacper Wysocki on 15/10/2025.
//

import UIKit
import Localize_Swift

class SplashViewController: UIViewController {
    private let backgroundImage = UIImageView()
    private let labelsStackView = UIStackView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let continueButton = UIButton()
    
    private let buttonHeight: CGFloat = .pt(44)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    func setupViews() {
        view.setGradientBackground(colorOne: .appOrange, colorTwo: .appWhite)
        
        [backgroundImage, labelsStackView, continueButton].forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }
        
        backgroundImage.image = .splashScreen
        
        titleLabel.text = "splash_title".localized()
        titleLabel.font = .poppinsSemiBold(size: 24)
        titleLabel.numberOfLines = 0
        
        descriptionLabel.text = "splash_description".localized()
        descriptionLabel.font = .poppinsRegular(size: 14)
        descriptionLabel.textColor = .backgroundGrey
        descriptionLabel.numberOfLines = 0
        
        labelsStackView.axis = .vertical
        labelsStackView.spacing = .pt(16)
        labelsStackView.addArrangedSubview(titleLabel)
        labelsStackView.addArrangedSubview(descriptionLabel)
        
        continueButton.addTarget(self, action: #selector (continueButtonTapped), for: .touchUpInside)
        continueButton.setTitle("splash_button_title".localized(), for: .normal)
        continueButton.backgroundColor = .appBlack
        continueButton.titleLabel?.font = .poppinsSemiBold(size: 14)
        continueButton.layer.cornerRadius = buttonHeight / 2
        
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .pt(100)),
            backgroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundImage.heightAnchor.constraint(lessThanOrEqualToConstant: .pt(600)),
            
            labelsStackView.topAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: .pt(32)),
            labelsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .pt(24)),
            labelsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.pt(24)),
            
            continueButton.topAnchor.constraint(greaterThanOrEqualTo: labelsStackView.bottomAnchor, constant: .pt(16)),
            continueButton.leadingAnchor.constraint(equalTo: labelsStackView.leadingAnchor),
            continueButton.trailingAnchor.constraint(equalTo: labelsStackView.trailingAnchor),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -.pt(16)),
            continueButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
    }
    
    @objc func continueButtonTapped() {
        AppNavigator.shared.navigate(to: MainRoutes.dashboard, with: .push)
    }
}
