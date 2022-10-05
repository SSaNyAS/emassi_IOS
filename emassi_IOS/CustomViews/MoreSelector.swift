//
//  MoreSelector.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 24.09.2022.
//

import Foundation
import UIKit

class MoreSelectorView: UIControl{
    var items: [MoreSelectorItem] = []{
        didSet{
            updateInputViews()
        }
    }
    weak var stackView: UIStackView!
    weak var plusButton: UIButton?
    
    private var allTextFieldTargets: (target: Any?,action: Selector,event: UIControl.Event)?
    
    public var isTextWritable: Bool = true{
        didSet{
            updateInputViews()
            if !isTextWritable{
                selectedItemsStored = []
                inputViews.removeAll()
            }
        }
    }
    
    private func updateInputViews(){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.stackView.arrangedSubviews.forEach({
                if let textField = $0 as? UITextField{
                    self.setInputViewToTextField(textField: textField)
                }
            })
        }
    }
    
    private func setInputViewToTextField(textField: UITextField){
        if self.isTextWritable{
            textField.inputView = nil
        } else {
            if textField.inputView != nil{
                setNewItemsSource()
            } else {
                let createdInputView = self.createNewInputView()
                textField.inputView = createdInputView
                createdInputView.parentTextField = textField
                textField.addTarget(self, action: #selector(didSelectNewValue), for: .editingDidEnd)
                setNewItemsSource()
            }
        }
    }
    
    private var inputViews: [UIPickerItemSelector] = []
    public var enteredTexts: [String]{
        return stackView.arrangedSubviews.compactMap({
            let text = ($0 as? UITextField)?.text
            if (text?.isEmpty ?? true){
                return nil
            }
            return text
        })
    }
    private var selectedItemsStored: [MoreSelectorItem] = []
    public var selectedItems: [MoreSelectorItem]{
        get{
            if isTextWritable{
                return selectedItemsStored
            }
            return inputViews.compactMap({$0.selectedItem})
        }
        set{
            setSelectedItems(selectedItems: newValue)
            if isTextWritable{
                selectedItemsStored = newValue
            }
        }
    }
      

    private func setSelectedItems(selectedItems: [MoreSelectorItem]){
        var textFieldsCount = stackView.arrangedSubviews.count
        if textFieldsCount > selectedItems.count {
            let difference = textFieldsCount - selectedItems.count
            for _ in 0..<difference{
                stackView.arrangedSubviews.last?.removeFromSuperview()
                if !isTextWritable{
                    inputViews.removeLast()
                }
            }
        }
        textFieldsCount = stackView.arrangedSubviews.count
        
        for itemId in 0..<selectedItems.count {
            let item = selectedItems[itemId]
            
            if itemId < textFieldsCount{
                if let textField = stackView.arrangedSubviews[itemId] as? UITextField{
                    textField.tag = itemId
                    DispatchQueue.main.async {
                        textField.text = item.name
                    }
                    setInputViewToTextField(textField: textField)
                    if let textFieldInput = textField.inputView as? UIPickerItemSelector{
                        textFieldInput.selectedItem = item
                    }
                    if let allTextFieldTargets = allTextFieldTargets{
                        textField.addTarget(allTextFieldTargets.target, action: allTextFieldTargets.action, for: allTextFieldTargets.event)
                    }
                }
            } else {
                let newField = createNewTextField()
                if let inputView = newField.inputView as? UIPickerItemSelector{
                    inputView.selectedItem = selectedItems[itemId]
                }
                else {
                    newField.text = item.name
                }
                
                if textFieldsCount > 0 {
                    let deleteButton = self.createRemoveFieldButton()
                    
                    newField.rightView = deleteButton
                    newField.rightViewMode = .unlessEditing
                    newField.rightViewRect(forBounds: deleteButton.bounds)
                    deleteButton.tag = itemId
                }
                
                self.stackView.addArrangedSubview(newField)
            }
        }
        textFieldsCount = stackView.arrangedSubviews.count
        if textFieldsCount < 1 {
            addNewTextField()
        }
        setNewItemsSource()
        setNeedsLayout()
    }
    
    @objc private func didSelectNewValue(){
        self.sendActions(for: .valueChanged)
        setNewItemsSource()
    }
    
    public func addTargetForAllTextFields(target: Any?, action: Selector, for event: UIControl.Event){
        allTextFieldTargets = (target, action, event)
    }
    
    public var selectedItemsValues: [any Hashable]{
        get{
            return selectedItems.map { $0.value }
        }
        set{
                let selectedItems = items.filter { item in
                    newValue.contains { newItem in
                        newItem.hashValue == item.value.hashValue
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
        addNewTextField() // add initial field
        
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
            addNewTextField()
            sendActions(for: .editingDidBegin)
        }
    }
    
    @objc private func removeFieldClick(sender: UIButton){
        let selectedItemId = sender.tag
        if selectedItemId >= 0 && selectedItemId < selectedItems.count{
            selectedItems.remove(at: selectedItemId)
        } else {
            let view = stackView.arrangedSubviews[selectedItemId]
            view.inputView?.removeFromSuperview()
            inputViews.removeAll(where: {
                $0 === view.inputView
            })
            view.removeFromSuperview()
            
        }
        sendActions(for: .valueChanged)
        setNeedsLayout()
    }
    
    private func addNewTextField(){
        let textField = createNewTextField()
        
        if stackView.arrangedSubviews.count > 0 {
            let deleteButton = self.createRemoveFieldButton()
            
            textField.rightView = deleteButton
            textField.rightViewMode = .unlessEditing
            textField.rightViewRect(forBounds: deleteButton.bounds)
            deleteButton.tag = stackView.arrangedSubviews.count
        }
        setInputViewToTextField(textField: textField)
        stackView.addArrangedSubview(textField)

    }
    
    func createNewTextField() -> UITextField{
        let textField = createNewField()
        if let allTextFieldTargets = allTextFieldTargets{
            textField.addTarget(allTextFieldTargets.target, action: allTextFieldTargets.action, for: allTextFieldTargets.event)
        }
        
        return textField
    }
    
    func createRemoveFieldButton() -> UIButton{
        let button = UIButton()
        button.setTitle(nil, for: .normal)
        button.setTitle(nil, for: .highlighted)
        button.contentMode = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let image = UIImage(systemName: "x.circle")?.withTintColor(.baseAppColor, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.setImage(image, for: .highlighted)
        button.setPreferredSymbolConfiguration(.init(pointSize: 25), forImageIn: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 23), forImageIn: .highlighted)
        button.widthAnchor.constraint(equalTo: button.heightAnchor,constant: 20).isActive = true
        
        button.addTarget(self, action: #selector(removeFieldClick(sender:)), for: .touchUpInside)
        return button
    }
    
    func createNewField() -> UITextField{
        let textField = UITextFieldEmassi()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.setCornerRadius(value: 12)
        textField.setTextLeftInset(value: 10)
        textField.setBorder()
        textField.backgroundColor = .clear
        textField.setContentHuggingPriority(.defaultLow, for: .vertical)
        let heightConstraint = textField.heightAnchor.constraint(equalToConstant: UITextFieldEmassi.defaultHeight)
        
        heightConstraint.priority = .defaultHigh
        heightConstraint.isActive = true
        return textField
    }
    
    func createNewInputView() -> UIPickerItemSelector{
        let inputView = UIPickerItemSelector()
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
    
    func getNotSelectedItems() -> Set<MoreSelectorItem>{
        let selectedSet = Set(selectedItems)
        let allItemsSet = Set(items)
        
        return allItemsSet.subtracting(selectedSet)
    }
}

struct MoreSelectorItem: Hashable, Equatable{
    
    static func == (lhs: MoreSelectorItem, rhs: MoreSelectorItem) -> Bool {
        lhs.value.hashValue == rhs.value.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
    
    var value: any Hashable
    var name: String
    
}
