//
//  UIPickerItemsSelector.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 25.09.2022.
//

import Foundation
import UIKit

class UIPickerItemSelector<Item>: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource where Item: Hashable{
    
    var items: [MoreSelectorItem<Item>] = []{
        didSet{
            DispatchQueue.main.async { [weak self] in
                self?.reloadAllComponents()
                if let selectedItemIndex = self?.getItemIndex(item: self?.selectedItem){
                    self?.selectRow(selectedItemIndex, inComponent: 0, animated: true)
                }
            }
        }
    }
    
    weak var parentTextField: UITextField?{
        didSet{
            let toolbar = UIToolbar()
            toolbar.barStyle = .default
            toolbar.sizeToFit()
            
            let cancelButton = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(closeButtonClick))
            cancelButton.setTitleTextAttributes([.foregroundColor: UIColor.systemRed], for: .normal)
            
            let doneButton = UIBarButtonItem(title: "Выбрать", style: .done, target: self, action: #selector(doneButtonClick))
            if #available(iOS 14.0, *) {
                toolbar.setItems([cancelButton,.flexibleSpace(),doneButton], animated: false)
            } else {
                toolbar.setItems([cancelButton,doneButton], animated: false)
            }
            
            parentTextField?.inputAccessoryView = toolbar
        }
    }
    
    @objc private func closeButtonClick(){
        parentTextField?.resignFirstResponder()
    }
    
    @objc private func doneButtonClick(){
        let selectedItemIndex = selectedRow(inComponent: 0)
        selectRow(selectedItemIndex, inComponent: 0, animated: false)
    }
    
    var selectedItem: MoreSelectorItem<Item>?{
        didSet{
            if selectedIndex == nil {
                if let itemIndex = getItemIndex(item: selectedItem){
                    selectRow(itemIndex, inComponent: 0, animated: false)
                }
            }
        }
    }
    var selectedIndex: IndexPath?
    
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
    
    private func setupDefaultSettings(){
        self.backgroundColor = .clear
        self.delegate = self
        self.dataSource = self
    }
    
    
    func getItemIndex(item: MoreSelectorItem<Item>?) -> Int?{
        if item == nil {
            return nil
        }
        let itemIndex = items.firstIndex(where: {
            $0.value == selectedItem?.value
        })
        return itemIndex
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    override func selectRow(_ row: Int, inComponent component: Int, animated: Bool) {
        super.selectRow(row, inComponent: component, animated: animated)
        if row >= 0 && row < items.count{
            selectItemByIndexPath(indexPath: .init(row: row, section: component))
        }
    }
    
    func selectItemByIndexPath(indexPath: IndexPath){
        selectedIndex = indexPath
        selectedItem = items[indexPath.row]
        parentTextField?.text = selectedItem?.name
        parentTextField?.resignFirstResponder()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectItemByIndexPath(indexPath: .init(row: row, section: component))
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row].name
    }
    
}
