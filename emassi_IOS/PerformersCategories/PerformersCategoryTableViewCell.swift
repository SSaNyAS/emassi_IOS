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
        setNeedsUpdateConstraints()
    }
    
    func setupDefaultSettings(){
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
        backgroundImageView = imageView
        backgroundColor = .clear
        
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 28, weight: .medium)
        label.textAlignment = .center
        
        contentView.contentMode = .scaleToFill
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
        
        NSLayoutConstraint.activate([
            
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
