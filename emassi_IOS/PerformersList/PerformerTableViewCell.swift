//
//  PerformerTableViewCell.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 09.09.2022.
//

import Foundation
import UIKit
class PerformerTableViewCell: UITableViewCell{
    public static var identifire: String = "PerformerTableViewCell"
    
    weak var photoImageView: UIImageView?
    weak var nameLabel: UILabel?
    weak var categoryLabel: UILabel?
    weak var ratingView: UIRatingView?
    weak var sendMessageButton: UIButton?
    weak var callButton: UIButton?
    weak var acceptButton: UIButton?
    weak var reviewLabel: UILabel?
    weak var showPerformerInfoButton: UIButton?
    weak var selectorView: UISwitch?
    var sendMessageButtonAction: (() ->Void)?
    var callButtonAction: (() ->Void)?
    var acceptButtonAction: (() ->Void)?
    private weak var buttonsContainer: UIStackView?
    
    public var isSelectingEnabled = false{
        didSet{
            if isSelectingEnabled{
                setupSelectorView()
                setupSelectorViewConstraints()
            }
            else {
                NSLayoutConstraint.deactivate(selectorView?.constraints ?? [])
                selectorView?.removeFromSuperview()
            }
            selectorView?.isHidden = !isSelectingEnabled
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if isSelectingEnabled{
            selectorView?.setOn(selected, animated: true)
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
    
    @objc func sendMessageButtonClick(){
        sendMessageButtonAction?()
    }
    @objc func callButtonClick(){
        callButtonAction?()
    }
    @objc func acceptButtonClick(){
        acceptButtonAction?()
    }
    
    func addSendMessageButton(title: String? = nil, action: @escaping () -> Void){
        if sendMessageButton == nil {
            setupSendMessageButton()
        }
        if let title = title {
            sendMessageButton?.setTitle(title, for: .normal)
        }
        sendMessageButtonAction = action
    }
    
    func addCallButton(title: String? = nil, action: @escaping () -> Void){
        if callButton == nil {
            setupCallButton()
        }
        if let title = title {
            callButton?.setTitle(title, for: .normal)
        }
        callButtonAction = action
    }
    
    func setReviewText(text: String){
        if reviewLabel == nil {
            setupReviewLabel()
            setupReviewLabelConstraints()
        }
        reviewLabel?.text = text
    }
    
    func addAcceptButton(title: String? = nil, action: @escaping () -> Void){
        if acceptButton == nil {
            setupAcceptButton()
        }
        if let title = title {
            acceptButton?.setTitle(title, for: .normal)
        }
        acceptButtonAction = action
    }
    
    func setupDefaultSettings(){
        setCornerRadius(value: 12)
        backgroundColor = .baseAppColor.withAlphaComponent(0.2)
        setupPhotoImageView()
        setupNameLabel()
        setupCategoryLabel()
        setupRatingView()
        setupButtonsCointainer()
        
        setupPhotoImageViewConstraints()
        setupNameLabelConstraints()
        setupCategoryLabelConstraints()
        setupRatingViewConstraints()
        setupButtonContainerConstraints()
        layoutIfNeeded()
    }
    
    func setupSelectorViewConstraints(){
        guard let selectorView = selectorView else {
            return
        }
        
        nameLabel?.trailingAnchor.constraint(lessThanOrEqualTo: selectorView.leadingAnchor, constant: -5).isActive = true
        categoryLabel?.trailingAnchor.constraint(lessThanOrEqualTo: selectorView.leadingAnchor, constant: -5).isActive = true
        ratingView?.trailingAnchor.constraint(lessThanOrEqualTo: selectorView.leadingAnchor, constant: -5).isActive = true
        buttonsContainer?.trailingAnchor.constraint(equalTo: selectorView.leadingAnchor, constant: -5).isActive = true
        reviewLabel?.trailingAnchor.constraint(equalTo: selectorView.leadingAnchor, constant: -5).isActive = true
        
        NSLayoutConstraint.activate([
            selectorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            selectorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
    }
    
    func setupSelectorView(){
        let selector = UICheckBoxEmassi()
        selector.isHidden = true
        selector.isUserInteractionEnabled = false
        selector.clipsToBounds = true
        selector.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(selector)
        selectorView = selector
    }
    
    func setupReviewLabelConstraints(){
        guard let reviewLabel = reviewLabel, let photoImageView = photoImageView else {
            return
        }
        let trailingConstraint = reviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        trailingConstraint.priority = .required
        
        NSLayoutConstraint.activate([
            reviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            reviewLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 10),
            trailingConstraint,
            reviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        ])
    }
    
    func setupReviewLabel(){
        let label = UILabelBordered()
        label.backgroundColor = .white
        label.isUseBorder = false
        label.cornerRadius = 12
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        reviewLabel = label
    }
    
    func setupAcceptButton(){
        let button = UIButtonEmassi()
        button.setTitle("Принять", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        buttonsContainer?.addArrangedSubview(button)
        button.addTarget(self, action: #selector(acceptButtonClick), for: .touchUpInside)
        acceptButton = button
    }
    
    func setupCallButton(){
        let button = UIButtonEmassi()
        button.setTitle("Вызов", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        buttonsContainer?.addArrangedSubview(button)
        button.addTarget(self, action: #selector(callButtonClick), for: .touchUpInside)
        callButton = button
    }
    
    func setupSendMessageButton(){
        let button = UIButtonEmassi()
        button.setTitle("Написать", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        buttonsContainer?.addArrangedSubview(button)
        button.addTarget(self, action: #selector(sendMessageButtonClick), for: .touchUpInside)
        sendMessageButton = button
    }
    
    func setupButtonContainerConstraints(){
        guard let buttonsContainer = buttonsContainer, let photoImageView = photoImageView, let ratingView = ratingView else {
            return
        }
        
        let topConstraint = buttonsContainer.topAnchor.constraint(greaterThanOrEqualTo: ratingView.bottomAnchor, constant: 5)
        
        topConstraint.priority = .defaultHigh
        
        let trailingConstraint = buttonsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        trailingConstraint.priority = .defaultHigh
                
        NSLayoutConstraint.activate([
            buttonsContainer.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 5),
            buttonsContainer.heightAnchor.constraint(equalToConstant: 32),
            buttonsContainer.bottomAnchor.constraint(equalTo: photoImageView.lastBaselineAnchor),
            trailingConstraint,
        ])
    }
    
    func setupButtonsCointainer(){
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.contentMode = .scaleToFill
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        buttonsContainer = stackView
    }
    
    func setupRatingViewConstraints(){
        guard let ratingView = ratingView, let photoImageView = photoImageView, let categoryLabel = categoryLabel else {
            return
        }
        let trailingConstraint = ratingView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -10)
        trailingConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            ratingView.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 5),
            ratingView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 5),
            trailingConstraint,
        ])
    }
    
    func setupRatingView(){
        let ratingView = UIRatingView()
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        ratingView.rating = 0
        contentView.addSubview(ratingView)
        self.ratingView = ratingView
    }
    
    func setupCategoryLabelConstraints(){
        guard let categoryLabel = categoryLabel, let nameLabel = nameLabel, let photoImageView = photoImageView else {
            return
        }
        let trailingConstraint = categoryLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -10)

        trailingConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 5),
            categoryLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,constant: 5),
            trailingConstraint,
        ])
    }
    
    func setupCategoryLabel(){
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        categoryLabel = label
    }
    
    func setupNameLabelConstraints(){
        guard let nameLabel = nameLabel, let photoImageView = photoImageView else {
            return
        }
        let trailingConstraint = nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -10)
        trailingConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 5),
            nameLabel.topAnchor.constraint(equalTo: photoImageView.firstBaselineAnchor),
            trailingConstraint,
        ])
    }
    
    func setupNameLabel(){
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16,weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        nameLabel = label
    }
    
    func setupPhotoImageViewConstraints(){
        guard let photoImageView = photoImageView else {
            return
        }
        let bottomConstraint = photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        bottomConstraint.priority = .defaultLow
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor, multiplier: 1.2),
            bottomConstraint
        ])
    }
    
    func setupPhotoImageView(){
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        self.photoImageView = imageView
    }
}
