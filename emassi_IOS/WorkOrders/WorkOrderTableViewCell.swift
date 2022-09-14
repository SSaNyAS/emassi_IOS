//
//  WorkOrderTableViewCell.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 14.09.2022.
//

import Foundation
import UIKit
class WorkOrderTableViewCell: UITableViewCell{
    static let identifire: String = "WorkOrderTableViewCell"
    
    weak var secondContentView: UIView!
    weak var orderTypeLabel: UILabel?
    weak var categoryLabel: UILabel?
    weak var dateLabel: UILabel?
    weak var addressLabel: UILabel?
    
    private weak var buttonsContainer: UIStackView?
    
    public var buttons: [UIButton]? {
        return buttonsContainer?.arrangedSubviews as? [UIButton]
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
        let secondContentView = UIView()
        secondContentView.backgroundColor = .baseAppColor.withAlphaComponent(0.2)
        secondContentView.setCornerRadius(value: 12)
        secondContentView.layer.masksToBounds = true
        secondContentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(secondContentView)
        contentView.layer.masksToBounds = true
        self.secondContentView = secondContentView
        
        NSLayoutConstraint.activate([
            secondContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            secondContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            secondContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            secondContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10)
        ])
        
        setupViews()
    }
    
    public func removeButton(with title: String){
        let findedButton = buttons?.first(where: {
            $0.title(for: .normal)?.lowercased() == title.lowercased()
        })
        findedButton?.removeFromSuperview()
        buttonsContainer?.setNeedsLayout()
    }
    
    public func createButton(title: String, action: @escaping ()->Void){
        let button = UIButtonEmassi()
        button.setTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        buttonsContainer?.addArrangedSubview(button)
        button.addTouchUpInsideAction(action: action)
        buttonsContainer?.setNeedsLayout()
    }
    
    private func setupViews(){
        createOrderTypeLabel()
        createCategoryLabel()
        createDateLabel()
        createAddressLabel()
        createButtonContainer()
        
        setupOrderTypeLabelConstraints()
        setupCategoryLabelConstraints()
        setupDateLabelConstraints()
        setupAddressLabelConstraints()
        setupButtonContainerConstraints()
    }
    
    private func setupButtonContainerConstraints(){
        guard let buttonsContainer = buttonsContainer else {
            return
        }
        if let addressLabel = addressLabel {
            buttonsContainer.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 10).isActive = true
        }
        NSLayoutConstraint.activate([
            buttonsContainer.leadingAnchor.constraint(greaterThanOrEqualTo: secondContentView.leadingAnchor, constant: 15),
            buttonsContainer.trailingAnchor.constraint(equalTo: secondContentView.trailingAnchor, constant: -15),
            buttonsContainer.bottomAnchor.constraint(equalTo: secondContentView.bottomAnchor, constant: -10),
        ])
    }
    
    private func createButtonContainer(){
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        stackView.alignment = .trailing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        secondContentView.addSubview(stackView)
        buttonsContainer = stackView
    }
    
    private func setupAddressLabelConstraints(){
        guard let addressLabel = addressLabel else {
            return
        }
        if let dateLabel = dateLabel {
            addressLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5).isActive = true
        }
        NSLayoutConstraint.activate([
            addressLabel.leadingAnchor.constraint(equalTo: secondContentView.leadingAnchor, constant: 15),
            addressLabel.trailingAnchor.constraint(lessThanOrEqualTo: secondContentView.trailingAnchor, constant: -15),
        ])
    }
    
    private func createAddressLabel(){
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        secondContentView.addSubview(label)
        addressLabel = label
    }
    
    private func setupDateLabelConstraints(){
        guard let dateLabel = dateLabel else {
            return
        }
        if let categoryLabel = categoryLabel {
            dateLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 5).isActive = true
        }
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: secondContentView.leadingAnchor, constant: 15),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: secondContentView.trailingAnchor, constant: -15),
        ])
    }
    
    private func createDateLabel(){
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        secondContentView.addSubview(label)
        dateLabel = label
    }
    
    private func setupCategoryLabelConstraints(){
        guard let categoryLabel = categoryLabel else {
            return
        }
        if let orderTypeLabel = orderTypeLabel {
            categoryLabel.topAnchor.constraint(equalTo: orderTypeLabel.bottomAnchor, constant: 5).isActive = true
        }
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: secondContentView.leadingAnchor, constant: 15),
            categoryLabel.trailingAnchor.constraint(lessThanOrEqualTo: secondContentView.trailingAnchor, constant: -15)
        ])
    }
    
    private func createCategoryLabel(){
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        secondContentView.addSubview(label)
        categoryLabel = label
    }
    
    private func setupOrderTypeLabelConstraints(){
        guard let orderTypeLabel = orderTypeLabel else {
            return
        }
        NSLayoutConstraint.activate([
            orderTypeLabel.leadingAnchor.constraint(equalTo: secondContentView.leadingAnchor, constant: 15),
            orderTypeLabel.topAnchor.constraint(equalTo: secondContentView.topAnchor, constant: 10),
            orderTypeLabel.trailingAnchor.constraint(lessThanOrEqualTo: secondContentView.trailingAnchor, constant: -15),
        ])
    }
    
    private func createOrderTypeLabel(){
        let label = UILabel()
        label.font = .systemFont(ofSize: 16,weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        secondContentView.addSubview(label)
        orderTypeLabel = label
    }
}
