//
//  PerformersCategoryHeaderView.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 17.10.2022.
//

import UIKit

class PerformersCategoryHeaderView: UITableViewHeaderFooterView {
    static let identifire: String = "PerformersCategoryHeaderView"
    weak var titleLabel: UILabel!
    weak var backgroundImageView: UIImageView!
    
    private weak var backgroundImageViewLeadingConstraint: NSLayoutConstraint?
    private weak var backgroundImageViewTrailingConstraint: NSLayoutConstraint?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupDefaultSettings()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDefaultSettings()
    }
    
    private func setupDefaultSettings(){
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        let maskView = UIView()
        maskView.backgroundColor = .black.withAlphaComponent(0.3)
        maskView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(maskView)
        
        NSLayoutConstraint.activate([
            maskView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            maskView.topAnchor.constraint(equalTo: imageView.topAnchor),
            maskView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            maskView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            maskView.widthAnchor.constraint(equalTo: imageView.widthAnchor),
            maskView.heightAnchor.constraint(equalTo: imageView.heightAnchor),
        ])
        
        imageView.setCornerRadius(value: 12)
        contentView.addSubview(imageView)
        backgroundImageView = imageView
        backgroundColor = .clear
        
        imageView.backgroundColor = .baseAppColorBackground
        
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 28, weight: .medium)
        label.textAlignment = .center
        
        contentView.addSubview(label)
        titleLabel = label
        setupCustomConstraints()
        setNeedsUpdateConstraints()
    }
    
    private func setupCustomConstraints(){
        guard let imageView = backgroundImageView, let label = titleLabel else {return}
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = imageView.heightAnchor.constraint(equalToConstant: 150)
        let widthConstraint = imageView.widthAnchor.constraint(equalToConstant: 350)
        
        heightConstraint.priority = .defaultHigh
        heightConstraint.isActive = true
        
        widthConstraint.priority = .defaultHigh
        widthConstraint.isActive = true
        
        let imageViewAspectRatio = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.4)
        imageViewAspectRatio.priority = .defaultHigh
        
        backgroundImageViewLeadingConstraint = imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        backgroundImageViewLeadingConstraint?.isActive = true
        
        backgroundImageViewTrailingConstraint = imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        backgroundImageViewTrailingConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            label.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: imageView.leadingAnchor, constant: 15),
            label.trailingAnchor.constraint(lessThanOrEqualTo: imageView.trailingAnchor, constant: -15),
            label.topAnchor.constraint(greaterThanOrEqualTo: imageView.topAnchor,constant: 15),
            label.bottomAnchor.constraint(lessThanOrEqualTo: imageView.bottomAnchor, constant: -15),
        ])
    }
}
