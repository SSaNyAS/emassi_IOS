//
//  DocumentTableViewCell.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 10.09.2022.
//

import Foundation
import UIKit
class DocumentTableViewCell: UITableViewCell{
    public static let identifire: String = "DocumentTableViewCell"
    weak var documentTypeLabel: UILabel?
    weak var documentImageView: UIImageView?
    weak var loadButton: UIButton?
    var loadButtonAction: (() -> Void)?
    
    public var isUsedPlaceholderImage: Bool {
        return documentImageView?.image === imagePlaceholder && imagePlaceholder != nil
    }
    
    @MainActor
    public var imagePlaceholder: UIImage? {
        didSet{
            if documentImageView?.image == nil {
                setImage(image: imagePlaceholder)
            } else {
                setImage(image: documentImage)
            }
        }
    }
    @MainActor
    public var documentImage: UIImage?{
        get{
            return documentImageView?.image
        }
        set {
            documentImageView?.image = newValue
            documentImageView?.isUserInteractionEnabled = isUsedPlaceholderImage
            documentImageView?.contentMode = isUsedPlaceholderImage ? .center : .scaleAspectFill
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupDefaultSettings()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDefaultSettings()
    }
    
    
    private func setupDefaultSettings(){
        self.selectionStyle = .none
        createDocumentTypeLabel()
        setupDocumentTypeLabelConstraints()
        
        createDocumentImageView()
        setupDocumentImageViewConstraints()
        
        createLoadButton()
        setupLoadButtonConstraints()
    }
    
    @objc private func loadButtonClick(){
        if isUsedPlaceholderImage{
            guard let documentImageView = documentImageView else {
                return
            }
            let savedAlpha = documentImageView.alpha
            let time = 0.2
            UIView.animate(withDuration: time, delay: 0, options: [.curveEaseIn]) { [weak documentImageView] in
                documentImageView?.alpha = savedAlpha * 0.6
            } completion: { [weak documentImageView] _ in
                UIView.animate(withDuration: time, delay: 0, options: [.curveEaseOut]) { [weak documentImageView] in
                    documentImageView?.alpha = savedAlpha
                }
            }
        }
        loadButtonAction?()
    }
    
    func setLoadButtonSettings(title: String, action: (() -> Void)? = nil){
        loadButton?.setTitle(title, for: .normal)
        if let action = action {
            loadButtonAction = action
        }
    }
    
    func setImagePlaceholder(image: UIImage?){
        imagePlaceholder = image
    }
    
    func setImage(image: UIImage?){
        documentImage = image
    }
    
    func setTitle(title: String){
        documentTypeLabel?.text = title
    }
    
    private func setupLoadButtonConstraints(){
        guard let loadButton = loadButton, let documentImageView = documentImageView else {
            return
        }
        
        NSLayoutConstraint.activate([
            loadButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            loadButton.topAnchor.constraint(equalTo: documentImageView.bottomAnchor, constant: 10),
            loadButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            loadButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    private func createLoadButton(){
        let button = UIButtonEmassi()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loadButtonClick), for: .touchUpInside)
        contentView.addSubview(button)
        loadButton = button
    }
    
    private func setupDocumentImageViewConstraints(){
        guard let documentImageView = documentImageView, let documentTypeLabel = documentTypeLabel else {
            return
        }
        let heightConstraint = documentImageView.heightAnchor.constraint(equalToConstant: 180)
        heightConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            documentImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            documentImageView.topAnchor.constraint(equalTo: documentTypeLabel.bottomAnchor, constant: 0),
            documentImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            heightConstraint
        ])
    }
    
    private func createDocumentImageView(){
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .center
        imageView.setCornerRadius(value: 12)
        imageView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(loadButtonClick))
        imageView.addGestureRecognizer(tapGesture)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        documentImageView = imageView
        imagePlaceholder = UIImage(systemName: "plus")?.applyingSymbolConfiguration(.init(pointSize: 70))?.withTintColor(.baseAppColor, renderingMode: .alwaysOriginal)
    }
    
    private func setupDocumentTypeLabelConstraints(){
        guard let documentTypeLabel = documentTypeLabel else {
            return
        }
        
        NSLayoutConstraint.activate([
            documentTypeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            documentTypeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            documentTypeLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -10),
        ])
    }
    
    private func createDocumentTypeLabel(){
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        documentTypeLabel = label
    }
    
}
