//
//  PerformersCategoryTableViewCell.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 03.09.2022.
//

import Foundation
import UIKit

class PerformersCategoryTableViewCell: UITableViewCell{
    public static var identifire: String = "PerformersCategoryTableViewCell"
    
    weak var backgroundImageView: UIImageView?
    weak var titleTextLabel: UILabel?
    private var isSetuppedConstraints = false
    weak private var backgroundImageViewLeadingConstraint: NSLayoutConstraint?
    weak private var backgroundImageViewTrailingConstraint: NSLayoutConstraint?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleTextLabel?.text = ""
        backgroundImageView?.image = nil
        backgroundImageView?.backgroundColor = .baseAppColorBackground
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupDefaultSettings()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDefaultSettings()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let constantToLeadingAndTrailing: CGFloat = selected ? 0 : 10
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.backgroundImageViewLeadingConstraint?.constant = constantToLeadingAndTrailing
            self?.backgroundImageViewTrailingConstraint?.constant = -constantToLeadingAndTrailing
        }
        
    }
    
    @MainActor
    public func setText(text: String){
        titleTextLabel?.text = text
        setNeedsUpdateConstraints()
    }
    
    @MainActor
    public func setImage(image: UIImage?){
        backgroundImageView?.image = image
        backgroundImageView?.backgroundColor = .clear
        setNeedsUpdateConstraints()
    }
    
    func setupDefaultSettings(){
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
        label.layer.zPosition = .infinity
        
        contentView.addSubview(label)
        titleTextLabel = label
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        if !isSetuppedConstraints {
            isSetuppedConstraints = true
            setupCustomConstraints()
        }
    }
    
    func setupCustomConstraints(){
        guard let imageView = backgroundImageView, let label = titleTextLabel else {return}
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = imageView.heightAnchor.constraint(equalToConstant: 150)
        let widthConstraint = imageView.widthAnchor.constraint(equalToConstant: 350)
        
        heightConstraint.priority = .defaultLow
        widthConstraint.priority = .defaultLow
        
        backgroundImageViewLeadingConstraint = imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10)
        backgroundImageViewLeadingConstraint?.isActive = true
        
        backgroundImageViewTrailingConstraint = imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10)
        backgroundImageViewTrailingConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            heightConstraint,
            widthConstraint,
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 150/350 ),
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
