//
//  ActiveWorksHeaderView.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 04.10.2022.
//

import UIKit

class ActiveWorksHeaderView: UITableViewHeaderFooterView {
    static let identifire: String = "ActiveWorksHeaderView"
    weak var contentViewSecond: UIView!
    weak var categoryLabel: UILabel?
    weak var dateTimeLabel: UILabel?
    weak var cancelButton: UIButton?
    weak var commentsTextLabel: UILabel?
    weak var showPerformersButton: UIButton?
    var didCancelWorkAction: (()-> Void)?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        categoryLabel?.text = ""
        dateTimeLabel?.text = ""
        commentsTextLabel?.text = ""
        didCancelWorkAction = nil
    }
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupDefaultSettings()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDefaultSettings()
    }
    
    @objc private func didCancelWork(){
        didCancelWorkAction?()
    }
    
    private func setupDefaultSettings(){
        let contentViewSecond = UIView()
        contentViewSecond.backgroundColor = .baseAppColorBackground
        contentViewSecond.setCornerRadius(value: 12)
        contentViewSecond.layer.masksToBounds = true
        contentViewSecond.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(contentViewSecond)
        self.contentViewSecond = contentViewSecond
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            self.contentView.topAnchor.constraint(equalTo: topAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            self.contentView.widthAnchor.constraint(equalTo: widthAnchor),
            
            contentViewSecond.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentViewSecond.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentViewSecond.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentViewSecond.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10),
            contentViewSecond.widthAnchor.constraint(equalTo: contentView.widthAnchor),
        ])
        
        createCategoryLabel()
        createDateTimeLabel()
        createCancelButton()
        createCommentsTextView()
        
        guard let categoryLabel = categoryLabel, let dateTimeLabel = dateTimeLabel, let cancelButton = cancelButton, let commentsTextView = commentsTextLabel else {
            return
        }
        
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: contentViewSecond.leadingAnchor,constant: 10),
            categoryLabel.topAnchor.constraint(equalTo: contentViewSecond.topAnchor,constant: 10),
            categoryLabel.trailingAnchor.constraint(lessThanOrEqualTo: cancelButton.leadingAnchor, constant: -10),
            
            cancelButton.trailingAnchor.constraint(equalTo: contentViewSecond.trailingAnchor,constant: -10),
            cancelButton.topAnchor.constraint(greaterThanOrEqualTo: contentViewSecond.topAnchor, constant: 10),
            cancelButton.bottomAnchor.constraint(equalTo: dateTimeLabel.bottomAnchor),
            cancelButton.widthAnchor.constraint(equalTo: contentViewSecond.widthAnchor, multiplier: 0.4),
            
            dateTimeLabel.leadingAnchor.constraint(equalTo: contentViewSecond.leadingAnchor,constant: 10),
            dateTimeLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor,constant: 5),
            dateTimeLabel.trailingAnchor.constraint(lessThanOrEqualTo: cancelButton.leadingAnchor, constant: -10),
            
            commentsTextView.topAnchor.constraint(equalTo: dateTimeLabel.bottomAnchor, constant: 10),
            commentsTextView.leadingAnchor.constraint(equalTo: contentViewSecond.leadingAnchor, constant: 10),
            commentsTextView.trailingAnchor.constraint(equalTo: contentViewSecond.trailingAnchor, constant: -10),
            commentsTextView.bottomAnchor.constraint(equalTo: contentViewSecond.bottomAnchor, constant: -10),
            
        ])
    }
}

//MARK: Create Views
extension ActiveWorksHeaderView{
    private func createCommentsTextView(){
        let label = UILabelBordered()
        label.font = .systemFont(ofSize: 16)
        label.layer.masksToBounds = true
        label.backgroundColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUseBorder = false
        
        contentViewSecond.addSubview(label)
        self.commentsTextLabel = label
    }
    
    private func createCancelButton(){
        let button = UIButtonEmassi()
        button.setTitle("Отменить", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didCancelWork), for: .touchUpInside)
        contentViewSecond.addSubview(button)
        self.cancelButton = button
    }
    
    private func createDateTimeLabel(){
        let label = createLabel()
        contentViewSecond.addSubview(label)
        self.dateTimeLabel = label
    }
    
    private func createCategoryLabel(){
        let label = createLabel()
        contentViewSecond.addSubview(label)
        self.categoryLabel = label
    }
    
    private func createLabel() -> UILabel{
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        return label
    }
}
