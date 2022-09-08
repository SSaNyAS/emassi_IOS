//
//  OnboardingCollectionViewCell.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 02.09.2022.
//

import Foundation
import UIKit
class OnboardingCollectionViewCell: UICollectionViewCell{
    static let identifire: String = "OnboardingCollectionViewCell"
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .bottom
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var onBoardTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26)
        label.textColor = .baseAppColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var onBoardDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .baseAppColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubViews()
    }
    
    func addSubViews(){
            self.contentView.addSubview(imageView)
            self.contentView.addSubview(onBoardTitleLabel)
            self.contentView.addSubview(onBoardDescriptionLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: onBoardTitleLabel.centerXAnchor),
            
            onBoardTitleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            onBoardTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            onBoardTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            onBoardDescriptionLabel.topAnchor.constraint(equalTo: onBoardTitleLabel.bottomAnchor, constant: 10),
            onBoardDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            onBoardDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            onBoardDescriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
}
