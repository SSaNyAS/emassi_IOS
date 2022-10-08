//
//  SettingTableViewCell.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 14.09.2022.
//

import Foundation
import UIKit
class SettingTableViewCell: UITableViewCell{
    static let identifire: String = "SettingTableViewCell"
    weak var secondContentView: UIView!
    weak var settingNameLabel: UILabel?
    
    public var imageTintColor: UIColor = .black{
        didSet{
            goSetupImageView?.tintColor = imageTintColor
        }
    }
    
    public var goSetupImage: UIImage? = UIImage(systemName: "chevron.right") {
        didSet{
            goSetupImageView?.image = goSetupImage
        }
    }
    
    private weak var goSetupImageView: UIImageView?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupDefaultSettings()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDefaultSettings()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.transform = selected ? .init(scaleX: 0.98, y: 0.98) : .identity
        }
    }
    
    private func setupDefaultSettings(){
        self.selectionStyle = .none
     let secondContentView = UIView()
        secondContentView.backgroundColor = .baseAppColorBackground
        secondContentView.setCornerRadius(value: 12)
        secondContentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(secondContentView)
        self.secondContentView = secondContentView
        
        NSLayoutConstraint.activate([
            secondContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            secondContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            secondContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            secondContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
        
        setupViews()
    }
    
    private func setupViews(){
        createSettingNameLabel()
        createGoSetupImageView()
        
        setupSettingNameLabelConstraints()
        setupGoSetupImageViewConstraints()
    }
    
    private func setupGoSetupImageViewConstraints(){
        guard let goSetupImageView = goSetupImageView else {
            return
        }
        
        if let settingNameLabel = settingNameLabel {
            settingNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: goSetupImageView.leadingAnchor, constant: -10).isActive  = true
        }
        
        NSLayoutConstraint.activate([
            goSetupImageView.centerYAnchor.constraint(equalTo: secondContentView.centerYAnchor),
            goSetupImageView.trailingAnchor.constraint(equalTo: secondContentView.trailingAnchor, constant: -10)
        ])
    }
    
    private func setupSettingNameLabelConstraints(){
        guard let settingNameLabel = settingNameLabel else {
            return
        }
        
        NSLayoutConstraint.activate([
            settingNameLabel.leadingAnchor.constraint(equalTo: secondContentView.leadingAnchor, constant: 10),
            settingNameLabel.topAnchor.constraint(equalTo: secondContentView.topAnchor,constant: 10),
            settingNameLabel.bottomAnchor.constraint(equalTo: secondContentView.bottomAnchor,constant: -10),
        ])
    }
    
    private func createGoSetupImageView(){
        let imageView = UIImageView()
        imageView.image = goSetupImage
        imageView.tintColor = imageTintColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        secondContentView.addSubview(imageView)
        goSetupImageView = imageView
    }
    
    private func createSettingNameLabel(){
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        secondContentView.addSubview(label)
        settingNameLabel = label
    }
    
}
