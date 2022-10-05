//
//  ActiveWorksHeaderView.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 04.10.2022.
//

import UIKit

class ActiveWorksHeaderView: UIView {
    weak var contentView: UIView!
    weak var categoryLabel: UILabel?
    weak var dateTimeLabel: UILabel?
    weak var cancelButton: UIButton?
    weak var commentsTextView: UITextView?
    weak var showPerformersButton: UIButton?
    
    var didCancelWorkAction: (()-> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaultSettings()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDefaultSettings()
    }
    
    @objc private func didCancelWork(){
        
    }
    
    private func setupDefaultSettings(){
        let contentView = UIView()
        contentView.backgroundColor = .baseAppColor.withAlphaComponent(0.2)
        contentView.setCornerRadius(value: 12)
        contentView.layer.masksToBounds = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentView)
        self.contentView = contentView
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -10),
            contentView.widthAnchor.constraint(equalTo: widthAnchor),
        ])
        
        createCategoryLabel()
        createDateTimeLabel()
        createCancelButton()
        createCommentsTextView()
        
        guard let categoryLabel = categoryLabel, let dateTimeLabel = dateTimeLabel, let cancelButton = cancelButton, let commentsTextView = commentsTextView else {
            return
        }
        
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            categoryLabel.trailingAnchor.constraint(lessThanOrEqualTo: cancelButton.leadingAnchor, constant: -10),
            
            cancelButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10),
            cancelButton.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 10),
            cancelButton.bottomAnchor.constraint(lessThanOrEqualTo: commentsTextView.topAnchor, constant: -10),
            cancelButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            
            dateTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            dateTimeLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor,constant: 5),
            dateTimeLabel.trailingAnchor.constraint(lessThanOrEqualTo: cancelButton.leadingAnchor, constant: -10),
            dateTimeLabel.topAnchor.constraint(equalTo: cancelButton.centerYAnchor, constant: 2.5),
            
            commentsTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            commentsTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            commentsTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
}

//MARK: Create Views
extension ActiveWorksHeaderView{
    
    private func createCommentsTextView(){
        let textView = UITextViewEmassi()
        textView.font = .systemFont(ofSize: 16)
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .label
        contentView.addSubview(textView)
        self.commentsTextView = textView
    }
    
    private func createCancelButton(){
        let button = UIButtonEmassi()
        button.setTitle("Отменить", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didCancelWork), for: .touchUpInside)
        contentView.addSubview(button)
        self.cancelButton = button
    }
    
    private func createDateTimeLabel(){
        let label = createLabel()
        contentView.addSubview(label)
        self.dateTimeLabel = label
    }
    
    private func createCategoryLabel(){
        let label = createLabel()
        contentView.addSubview(label)
        self.categoryLabel = label
    }
    
    private func createLabel() -> UILabel{
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        //label.setContentHuggingPriority(.required, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        return label
    }
}
