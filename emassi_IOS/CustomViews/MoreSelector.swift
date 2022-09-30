//
//  MoreSelector.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 24.09.2022.
//

import Foundation
import UIKit

class MoreSelectorView<Item>: UIView where Item: Hashable{
    var items: [MoreSelectorItem<Item>] = []
    weak var stackView: UIStackView?
    weak var plusButton: UIButton?
    public var isTextWritable: Bool = true{
        didSet{
                clearSubviews()
                _ = addNewField()
        }
    }
    private var inputViews: [UIPickerItemSelector<Item>] = []
    public var enteredTexts: [String]{
        return stackView?.arrangedSubviews.compactMap({
            let text = ($0 as? UITextField)?.text
            if (text?.isEmpty ?? true){
                return nil
            }
            return text
        }) ?? []
    }
    public var selectedItems: [MoreSelectorItem<Item>]{
        get{
            return inputViews.compactMap({$0.selectedItem})
        }
        set{
            if newValue.count > 0{
                clearSubviews()
                for itemId in 0..<newValue.count{
                    let newField = addNewField()
                    if let inputView = newField.inputView as? UIPickerItemSelector<Item>{
                        inputView.selectedItem = newValue[itemId]
                    }
                }
            } else {
                clearSubviews()
                _ = addNewField()
            }
        }
    }
    @objc private func didSelectNewValue(){
        setNewItemsSource()
    }
    private func clearSubviews(){
        stackView?.arrangedSubviews.forEach({$0.removeFromSuperview()})
        inputViews.forEach({$0.removeFromSuperview()})
        inputViews = []
    }
    
    public var selectedItemsValues: [Item]{
        get{
            return selectedItems.map { $0.value }
        }
        set{
                let selectedItems = items.filter { item in
                    newValue.contains { newItem in
                        newItem == item.value
                    }
                }
            self.selectedItems = selectedItems
        }
    }
    
    public var buttonImage: UIImage? = UIImage(systemName: "plus.circle")?.withTintColor(.baseAppColor, renderingMode: .alwaysOriginal){
        didSet{
            DispatchQueue.main.async { [weak plusButton, weak buttonImage] in
                plusButton?.setImage(buttonImage, for: .normal)
                plusButton?.setImage(buttonImage, for: .highlighted)
            }
        }
    }
    
    init(){
        super.init(frame: .zero)
        setupDefaultSettings()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaultSettings()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDefaultSettings()
    }
    
    func setupDefaultSettings(){
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        self.stackView = stackView
        let plusButton = UIButton()
        plusButton.addTarget(self, action: #selector(plusButtonClick), for: .touchUpInside)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.contentMode = .scaleAspectFill
        plusButton.setPreferredSymbolConfiguration(.init(pointSize: 25), forImageIn: .normal)
        plusButton.setPreferredSymbolConfiguration(.init(pointSize: 23), forImageIn: .highlighted)
        plusButton.setContentHuggingPriority(.required, for: .horizontal)
        addSubview(plusButton)
        self.plusButton = plusButton
        
        self.buttonImage = buttonImage?.withRenderingMode(.alwaysOriginal)
        _ = addNewField() // add initial field
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: -5),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            plusButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            plusButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            plusButton.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor),
            plusButton.heightAnchor.constraint(equalTo: plusButton.widthAnchor),
            plusButton.heightAnchor.constraint(equalToConstant: UITextFieldEmassi.defaultHeight)
        ])
        
    }
    
    @objc private func plusButtonClick(){
        let text = (stackView?.arrangedSubviews.last as? UITextField)?.text
        if text != nil && !(text?.isEmpty ?? true){
            _ = addNewField()
        }
    }
    
    func addNewField() -> UITextField{
        let textField = createNewField()
        setNewItemsSource()
        DispatchQueue.main.async { [weak self] in
            self?.stackView?.addArrangedSubview(textField)
        }
        return textField
    }
    
    func createNewField() -> UITextField{
        let textField = UITextFieldEmassi()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.setCornerRadius(value: 12)
        textField.setTextLeftInset(value: 10)
        textField.setBorder()
        textField.backgroundColor = .clear
        textField.heightAnchor.constraint(equalToConstant: UITextFieldEmassi.defaultHeight).isActive = true
        if !isTextWritable{
            let createdInputView = createNewInputView()
            textField.inputView = createdInputView
            createdInputView.parentTextField = textField
            textField.addTarget(self, action: #selector(didSelectNewValue), for: .editingDidEnd)
        }
        return textField
    }
    
    func createNewInputView() -> UIPickerItemSelector<Item>{
        let inputView = UIPickerItemSelector<Item>()
        inputViews.append(inputView)
        return inputView
    }
    
    func setNewItemsSource(){
        let notSelected = getNotSelectedItems()
        inputViews.forEach({
            if let selectedItem = $0.selectedItem{
                var notSelectedCopy = notSelected
                notSelectedCopy.insert(selectedItem)
                $0.items = notSelectedCopy.sorted(by: {$0.name < $1.name})
            } else {
                $0.items = notSelected.sorted(by: {$0.name < $1.name})
            }
        })
    }
    
    func getNotSelectedItems() -> Set<MoreSelectorItem<Item>>{
        let selectedSet = Set(selectedItems)
        let allItemsSet = Set(items)
        
        return allItemsSet.subtracting(selectedSet)
    }
}

protocol MoreSelectorItemProtocol: Equatable{
    associatedtype ItemType
    var name: String{get}
    var value: ItemType{get}
}

struct MoreSelectorItem<Item>: MoreSelectorItemProtocol,Hashable, Equatable where Item: Hashable{
    
    static func == (lhs: MoreSelectorItem<Item>, rhs: MoreSelectorItem<Item>) -> Bool {
        lhs.value == rhs.value
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
    
    typealias Item = Item where Item: Hashable
    var value: Item
    var name: String
    
}
