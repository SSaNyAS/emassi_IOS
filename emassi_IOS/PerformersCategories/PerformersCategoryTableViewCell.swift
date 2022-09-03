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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupDefaultSettings()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDefaultSettings()
    }
    
    @MainActor
    public func setText(text: String){
        titleTextLabel?.text = text
        setNeedsUpdateConstraints()
    }
    
    @MainActor
    public func setImage(image: UIImage?){
        backgroundImageView?.image = image
    }
    
    func setupDefaultSettings(){
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        backgroundView = imageView
        
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 28, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])
        
    }
}
