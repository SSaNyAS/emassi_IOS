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
    lazy var imageView: UIImageView? = {
        let imageView = UIImageView()
        imageView.backgroundColor = .orange
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var onBoardTitleLabel: UILabel? = {
        let label = UILabel()
        label.backgroundColor = .green
        label.font = .systemFont(ofSize: 26)
        label.textColor = .baseAppColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var onBoardDescriptionLabel: UILabel? = {
        let label = UILabel()
        label.backgroundColor = .green
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
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        if let imageView = imageView {
            self.contentView.addSubview(imageView)
        }
        if let onBoardTitleLabel = onBoardTitleLabel {
            self.contentView.addSubview(onBoardTitleLabel)
        }
        if let onBoardDescriptionLabel = onBoardDescriptionLabel {
            self.contentView.addSubview(onBoardDescriptionLabel)
        }
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        guard let imageView = imageView else {
            return
        }
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
        guard let onBoardTitleLabel = onBoardTitleLabel else {
            return
        }
        NSLayoutConstraint.activate([
            onBoardTitleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            onBoardTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            onBoardTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        guard let onBoardDescriptionLabel = onBoardDescriptionLabel else {
            return
        }
        NSLayoutConstraint.activate([
            onBoardDescriptionLabel.topAnchor.constraint(equalTo: onBoardTitleLabel.bottomAnchor, constant: 10),
            onBoardDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            onBoardDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            onBoardDescriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
