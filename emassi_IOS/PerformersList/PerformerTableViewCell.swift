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
    weak var contentViewSecond: UIView!
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
    private var isSetuppedConstraints: Bool = false
    public var isSelectingEnabled = false{
        didSet{
            if isSelectingEnabled{
                if selectorView == nil {
                    setupSelectorView()
                    setupSelectorViewConstraints()
                } else {
                    NSLayoutConstraint.deactivate(selectorView?.constraints ?? [])
                    selectorView?.removeFromSuperview()
                    selectorView = nil
                    setupSelectorView()
                    setupSelectorViewConstraints()
                }
            }
            else {
                NSLayoutConstraint.deactivate(selectorView?.constraints ?? [])
                selectorView?.removeFromSuperview()
                selectorView = nil
            }
            selectorView?.isHidden = !isSelectingEnabled
            setNeedsLayout()
        }
    }
    
    override var isSelected: Bool{
        get{
            return selectorView?.isOn ?? false
        }
        set{
            if isSelectingEnabled{
                selectorView?.setOn(newValue, animated: true)
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)
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
    
    @objc private func sendMessageButtonClick(){
        sendMessageButtonAction?()
    }
    @objc private func callButtonClick(){
        callButtonAction?()
    }
    @objc private func acceptButtonClick(){
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isSelectingEnabled = false
        
        sendMessageButton?.removeTarget(self, action: #selector(sendMessageButtonClick), for: .touchUpInside)
        sendMessageButton?.removeFromSuperview()
        sendMessageButton = nil
        
        callButton?.removeTarget(self, action: #selector(callButtonClick), for: .touchUpInside)
        callButton?.removeFromSuperview()
        callButton = nil
        
        acceptButton?.removeTarget(self, action: #selector(acceptButtonClick), for: .touchUpInside)
        acceptButton?.removeFromSuperview()
        acceptButton = nil
        
        reviewLabel?.removeFromSuperview()
        reviewLabel = nil
        
        sendMessageButtonAction = nil
        callButtonAction = nil
        acceptButtonAction = nil
    }
    
    private func setupDefaultSettings(){
        
        if !isSetuppedConstraints{
            let contentViewSecond = UIView()
            contentViewSecond.isUserInteractionEnabled = true
            contentViewSecond.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(contentViewSecond)
            self.contentViewSecond = contentViewSecond
            
            NSLayoutConstraint.activate([
                contentViewSecond.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                contentViewSecond.topAnchor.constraint(equalTo: contentView.topAnchor),
                contentViewSecond.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                contentViewSecond.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
                contentViewSecond.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            ])
            
            contentViewSecond.backgroundColor = .baseAppColor.withAlphaComponent(0.2)
            contentViewSecond.setCornerRadius(value: 12)
            
            selectionStyle = .none

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
            isSetuppedConstraints = true
        }
        layoutIfNeeded()
    }
    
    private func setupSelectorViewConstraints(){
        guard let selectorView = selectorView else {
            return
        }
        
        nameLabel?.trailingAnchor.constraint(lessThanOrEqualTo: selectorView.leadingAnchor, constant: -5).isActive = true
        categoryLabel?.trailingAnchor.constraint(lessThanOrEqualTo: selectorView.leadingAnchor, constant: -5).isActive = true
        ratingView?.trailingAnchor.constraint(lessThanOrEqualTo: selectorView.leadingAnchor, constant: -5).isActive = true
        buttonsContainer?.trailingAnchor.constraint(equalTo: selectorView.leadingAnchor, constant: -5).isActive = true
        
        if let reviewLabel = reviewLabel {
            if !(reviewLabel.constraints.contains(where: {$0.secondItem === selectorView}) ){
                reviewLabel.trailingAnchor.constraint(equalTo: selectorView.leadingAnchor, constant: -5).isActive = true
            }
        }
        
        NSLayoutConstraint.activate([
            selectorView.centerYAnchor.constraint(equalTo: contentViewSecond.centerYAnchor),
            selectorView.trailingAnchor.constraint(equalTo: contentViewSecond.trailingAnchor, constant: -10),
        ])
    }
    
    private func setupSelectorView(){
        let selector = UICheckBoxEmassi()
        selector.isHidden = true
        selector.isUserInteractionEnabled = false
        selector.clipsToBounds = true
        selector.translatesAutoresizingMaskIntoConstraints = false
        contentViewSecond.addSubview(selector)
        selectorView = selector
    }
    
    private func setupReviewLabelConstraints(){
        guard let reviewLabel = reviewLabel, let photoImageView = photoImageView else {
            return
        }
        let trailingConstraint = reviewLabel.trailingAnchor.constraint(equalTo: contentViewSecond.trailingAnchor, constant: -10)
        trailingConstraint.priority = .defaultHigh
        if let selectorView = selectorView {
            reviewLabel.trailingAnchor.constraint(equalTo: selectorView.leadingAnchor, constant: -5).isActive = true
        }
        NSLayoutConstraint.activate([
            reviewLabel.leadingAnchor.constraint(equalTo: contentViewSecond.leadingAnchor, constant: 10),
            reviewLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 10),
            trailingConstraint,
            reviewLabel.bottomAnchor.constraint(equalTo: contentViewSecond.bottomAnchor, constant: -5),
        ])
    }
    
    private func setupReviewLabel(){
        let label = UILabelBordered()
        label.backgroundColor = .white
        label.isUseBorder = false
        label.cornerRadius = 12
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        contentViewSecond.addSubview(label)
        reviewLabel = label
    }
    
    private func setupAcceptButton(){
        let button = UIButtonEmassi()
        button.setTitle("Принять", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        buttonsContainer?.addArrangedSubview(button)
        button.addTarget(self, action: #selector(acceptButtonClick), for: .touchUpInside)
        acceptButton = button
    }
    
    private func setupCallButton(){
        let button = UIButtonEmassi()
        button.setTitle("Вызов", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        buttonsContainer?.addArrangedSubview(button)
        button.addTarget(self, action: #selector(callButtonClick), for: .touchUpInside)
        callButton = button
    }
    
    private func setupSendMessageButton(){
        let button = UIButtonEmassi()
        button.setTitle("Написать", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        buttonsContainer?.addArrangedSubview(button)
        button.addTarget(self, action: #selector(sendMessageButtonClick), for: .touchUpInside)
        sendMessageButton = button
    }
    
    private func setupButtonContainerConstraints(){
        guard let buttonsContainer = buttonsContainer, let photoImageView = photoImageView, let ratingView = ratingView else {
            return
        }
        
        let topConstraint = buttonsContainer.topAnchor.constraint(greaterThanOrEqualTo: ratingView.bottomAnchor, constant: 5)
        
        topConstraint.priority = .defaultHigh
        
        let trailingConstraint = buttonsContainer.trailingAnchor.constraint(equalTo: contentViewSecond.trailingAnchor, constant: -10)
        trailingConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            topConstraint,
            buttonsContainer.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 5),
            
            buttonsContainer.heightAnchor.constraint(equalToConstant: 32),
            buttonsContainer.bottomAnchor.constraint(equalTo: photoImageView.lastBaselineAnchor),
            trailingConstraint,
        ])
    }
    
    private func setupButtonsCointainer(){
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.contentMode = .scaleToFill
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentViewSecond.addSubview(stackView)
        buttonsContainer = stackView
    }

    private func setupRatingViewConstraints(){
        guard let ratingView = ratingView, let photoImageView = photoImageView, let categoryLabel = categoryLabel else {
            return
        }
        let trailingConstraint = ratingView.trailingAnchor.constraint(lessThanOrEqualTo: contentViewSecond.trailingAnchor, constant: -10)
        trailingConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            ratingView.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 5),
            ratingView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 5),
            trailingConstraint,
        ])
    }
    
    private func setupRatingView(){
        let ratingView = UIRatingView()
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        ratingView.rating = 0
        contentViewSecond.addSubview(ratingView)
        self.ratingView = ratingView
    }
    
    private func setupCategoryLabelConstraints(){
        guard let categoryLabel = categoryLabel, let nameLabel = nameLabel, let photoImageView = photoImageView else {
            return
        }
        let trailingConstraint = categoryLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentViewSecond.trailingAnchor, constant: -10)

        trailingConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 5),
            categoryLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,constant: 5),
            trailingConstraint,
        ])
    }
    
    private func setupCategoryLabel(){
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentViewSecond.addSubview(label)
        categoryLabel = label
    }
    
    private func setupNameLabelConstraints(){
        guard let nameLabel = nameLabel, let photoImageView = photoImageView else {
            return
        }
        let trailingConstraint = nameLabel.trailingAnchor.constraint(equalTo: contentViewSecond.trailingAnchor, constant: -10)
        trailingConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 5),
            nameLabel.topAnchor.constraint(equalTo: photoImageView.firstBaselineAnchor),
            trailingConstraint,
        ])
    }
    
    private func setupNameLabel(){
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16,weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentViewSecond.addSubview(label)
        nameLabel = label
    }
    
    private func setupPhotoImageViewConstraints(){
        guard let photoImageView = photoImageView else {
            return
        }
        let bottomConstraint = photoImageView.bottomAnchor.constraint(equalTo: contentViewSecond.bottomAnchor, constant: -10)
        bottomConstraint.priority = .defaultLow
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: contentViewSecond.leadingAnchor, constant: 10),
            photoImageView.topAnchor.constraint(equalTo: contentViewSecond.topAnchor, constant: 5),
            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor, multiplier: 1.2),
            bottomConstraint
        ])
    }
    
    private func setupPhotoImageView(){
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentViewSecond.addSubview(imageView)
        self.photoImageView = imageView
    }

}
