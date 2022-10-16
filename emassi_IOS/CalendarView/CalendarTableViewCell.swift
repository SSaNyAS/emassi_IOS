//
//  CalendarTableViewCell.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 16.10.2022.
//

import UIKit

class CalendarTableViewCell: UITableViewCell{
    static let identifire: String = "CalendarCell"
    weak var dayLabel: UILabel!
    weak var ordersStackView: UIStackView!
    weak var showAllOrdersButton: UIButton!
    
    private weak var verticalSeparator: UIView!
    private weak var bottomHorizontalSeparator: UIView!
    private weak var vertivalSeparatorWidthConstraint: NSLayoutConstraint?
    private weak var horizontalSeparatorHeightConstraint: NSLayoutConstraint?
    
    public var separatorColor: UIColor = .placeholderText{
        didSet{
            DispatchQueue.main.async {
                self.verticalSeparator.backgroundColor = self.separatorColor
                self.bottomHorizontalSeparator.backgroundColor = self.separatorColor
            }
        }
    }
    
    public var separatorsWidth: CGFloat = 2{
        didSet{
            DispatchQueue.main.async {
                self.vertivalSeparatorWidthConstraint?.constant = self.separatorsWidth
                self.horizontalSeparatorHeightConstraint?.constant = self.separatorsWidth
            }
        }
    }
    
    public var ordersLabelsBackgroundColor: UIColor = .baseAppColorBackground{
        didSet{
            DispatchQueue.main.async {
                self.ordersStackView.backgroundColor = self.ordersLabelsBackgroundColor
            }
        }
    }
    
    public var showAllOrdersAction: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupDefaultSettings()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDefaultSettings()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.ordersStackView.arrangedSubviews.forEach({
            $0.removeFromSuperview()
        })
        self.dayLabel.text = ""
        self.showAllOrdersAction = nil
    }
    
    func addDateEvent(event: String){
        DispatchQueue.main.async {
            let label = self.createEventLabel()
            label.text = event
        }
    }
    
    @objc private func showAllOrdersButtonClick(){
        showAllOrdersAction?()
    }
}

// MARK: Setup views
extension CalendarTableViewCell{
    private func setupDefaultSettings(){
        selectionStyle = .none
        self.separatorInset = .zero
        createDayLabel()
        
        let verticalSeparator = createSeparator()
        let horizontalSeparator = createSeparator()
        contentView.addSubview(verticalSeparator)
        contentView.addSubview(horizontalSeparator)
        self.verticalSeparator = verticalSeparator
        self.bottomHorizontalSeparator = horizontalSeparator
        
        createOrdersStackView()
        createShowAllOrdersButton()
        
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dayLabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 5),
            dayLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor,multiplier: 0.14),
            dayLabel.bottomAnchor.constraint(lessThanOrEqualTo: horizontalSeparator.topAnchor, constant: -5),
            
            verticalSeparator.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor),
            verticalSeparator.topAnchor.constraint(equalTo: contentView.topAnchor),
            verticalSeparator.bottomAnchor.constraint(equalTo: horizontalSeparator.topAnchor),
            verticalSeparator.widthAnchor.constraint(equalToConstant: separatorsWidth),
            
            horizontalSeparator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalSeparator.trailingAnchor.constraint(equalTo: trailingAnchor),
            horizontalSeparator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            horizontalSeparator.heightAnchor.constraint(equalToConstant: separatorsWidth),
            
            ordersStackView.leadingAnchor.constraint(equalTo: verticalSeparator.trailingAnchor),
            ordersStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            ordersStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ordersStackView.bottomAnchor.constraint(equalTo: showAllOrdersButton.topAnchor, constant: -5),
            
            showAllOrdersButton.leadingAnchor.constraint(greaterThanOrEqualTo: verticalSeparator.trailingAnchor, constant: 10),
            showAllOrdersButton.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -10),
            showAllOrdersButton.centerXAnchor.constraint(equalTo: ordersStackView.centerXAnchor),
            showAllOrdersButton.bottomAnchor.constraint(lessThanOrEqualTo: horizontalSeparator.topAnchor, constant: -5),
            
        ])
        
        setNeedsLayout()
    }
    
    private func createShowAllOrdersButton(){
        let button = UIButtonEmassi()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Посмотреть все заявки", for: .normal)
        button.addTarget(self, action: #selector(showAllOrdersButtonClick), for: .touchUpInside)
        contentView.addSubview(button)
        self.showAllOrdersButton = button
    }
    
    private func createOrdersStackView(){
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .top
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = ordersLabelsBackgroundColor
        contentView.addSubview(stackView)
        self.ordersStackView = stackView
    }
    
    private func createSeparator() -> UIView{
        let view = UIView()
        view.backgroundColor = separatorColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    private func createEventLabel() -> UILabel{
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        ordersStackView.addArrangedSubview(label)
        return label
    }
    
    private func createDayLabel(){
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        self.dayLabel = label
    }
}
