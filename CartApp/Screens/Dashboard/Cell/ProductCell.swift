//
//  ProductCell.swift
//  CartApp
//
//  Created by Kacper Wysocki on 15/10/2025.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import Localize_Swift

class ProductCell: UITableViewCell {
    static let identifier = "ProductCell"
    var onAddTapped: (() -> Void)?
    var onRemoveTapped: (() -> Void)?
    
    // CHANGED: Usunięto nieużywany disposeBag (nie ma subskrypcji w komórce)
    // private let disposeBag = DisposeBag()
    
    // CHANGED: Dodano przechowywanie productID dla bezpiecznej identyfikacji
    private var productID: Int?
    
    private let productContentView = UIView()
    private let productImageView = UIImageView()
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let unitLabel = UILabel()
    
    private let addButton = UIButton(type: .system)
    private let removeButton = UIButton(type: .system)
    private let quantityLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productID = nil
        nameLabel.text = nil
        priceLabel.text = nil
        unitLabel.text = nil
        quantityLabel.text = "0"
        productImageView.kf.cancelDownloadTask()
        productImageView.image = nil
    }
    
    private func setupViews() {
        selectionStyle = .none
        backgroundColor = .clear
        productContentView.backgroundColor = .white
        productContentView.layer.cornerRadius = 8
        
        productImageView.contentMode = .scaleAspectFill
        productImageView.layer.cornerRadius = 10
        productImageView.clipsToBounds = true
        
        nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        priceLabel.font = .systemFont(ofSize: 15, weight: .medium)
        priceLabel.textColor = .systemOrange
        unitLabel.font = .systemFont(ofSize: 13)
        unitLabel.textColor = .gray
        
        addButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        addButton.tintColor = .systemGreen
        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        
        removeButton.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        removeButton.tintColor = .systemRed
        removeButton.addTarget(self, action: #selector(removeTapped), for: .touchUpInside)
        
        quantityLabel.font = .systemFont(ofSize: 14, weight: .medium)
        quantityLabel.textAlignment = .center
        quantityLabel.textColor = .label
        quantityLabel.text = "0"
        
        addButton.accessibilityIdentifier = "ProductCell.addButton"
        removeButton.accessibilityIdentifier = "ProductCell.removeButton"
        quantityLabel.accessibilityIdentifier = "ProductCell.quantityLabel"
        nameLabel.accessibilityIdentifier = "ProductCell.nameLabel"
        
        productContentView.addSubview(productImageView)
        productContentView.addSubview(nameLabel)
        productContentView.addSubview(priceLabel)
        productContentView.addSubview(unitLabel)
        productContentView.addSubview(addButton)
        productContentView.addSubview(removeButton)
        productContentView.addSubview(quantityLabel)
        
        contentView.addSubview(productContentView)
    }
    
    private func setupConstraints() {
        productContentView.translatesAutoresizingMaskIntoConstraints = false
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        unitLabel.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productContentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .pt(8)),
            productContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.pt(8)),
            productContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .pt(8)),
            productContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.pt(8)),
            
            productImageView.leadingAnchor.constraint(equalTo: productContentView.leadingAnchor, constant: .pt(16)),
            productImageView.topAnchor.constraint(equalTo: productContentView.topAnchor, constant: .pt(10)),
            productImageView.bottomAnchor.constraint(equalTo: productContentView.bottomAnchor, constant: -.pt(10)),
            productImageView.widthAnchor.constraint(equalToConstant: .pt(80)),
            
            nameLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: .pt(12)),
            nameLabel.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -.pt(8)),
            nameLabel.topAnchor.constraint(equalTo: productContentView.topAnchor, constant: .pt(12)),
            
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: .pt(4)),
            
            unitLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            unitLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: .pt(4)),
            
            addButton.trailingAnchor.constraint(equalTo: productContentView.trailingAnchor, constant: -.pt(16)),
            addButton.centerYAnchor.constraint(equalTo: productContentView.centerYAnchor),
            addButton.widthAnchor.constraint(equalToConstant: .pt(30)),
            addButton.heightAnchor.constraint(equalToConstant: .pt(30)),
            
            quantityLabel.centerYAnchor.constraint(equalTo: productContentView.centerYAnchor),
            quantityLabel.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -.pt(8)),
            quantityLabel.widthAnchor.constraint(equalToConstant: .pt(25)),
            
            removeButton.centerYAnchor.constraint(equalTo: productContentView.centerYAnchor),
            removeButton.trailingAnchor.constraint(equalTo: quantityLabel.leadingAnchor, constant: -.pt(8)),
            removeButton.widthAnchor.constraint(equalToConstant: .pt(30)),
            removeButton.heightAnchor.constraint(equalToConstant: .pt(30))
        ])
    }
    
    func configure(with product: Product) {
        productID = product.id
        
        nameLabel.text = product.name
        priceLabel.text = String(format: "price_format".localized(), product.price, product.currency)
        unitLabel.text = String(format: "product_unit".localized(), product.unit)
        loadImage(from: product.imageUrl)
    }
    
    func updateQuantity(_ quantity: Int) {
        quantityLabel.text = "\(quantity)"
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        productImageView.kf.setImage(with: url)
    }
    
    @objc private func addTapped() {
        onAddTapped?()
    }
    
    @objc private func removeTapped() {
        onRemoveTapped?()
    }
}
