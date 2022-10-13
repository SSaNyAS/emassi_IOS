//
//  PerformersCategoriesTableViewDataSource.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 05.09.2022.
//

import Foundation
import UIKit
class PerformersCategoriesTableViewDataSourceDelegate: NSObject, UITableViewDataSource, UITableViewDelegate{
    public var performersCategories: [PerformersCategory] = []
    weak var tableView: UITableView?
    public var didSelectCategoryAction: ((_ category: String) -> Void)?
    static let subCategoryCellIdentifire = "subCategoryCell"
    
    func searchAndScroollToRow(searchText: String){
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self, let tableView = self.tableView else {
                return
            }
            
            let searchText = searchText.lowercased()
            for categoryId in 0..<self.performersCategories.count{
                self.performersCategories[categoryId].isOpened = true
            }
            DispatchQueue.main.async {
                tableView.reloadData()
            }
            
            var itemIndexPath: IndexPath?
            let firstIndex = self.performersCategories.firstIndex { category in
                for itemId in 0..<category.subCategories.count{
                    let isContains = category.subCategories[itemId].name.lowercased().contains(searchText)
                    if isContains{
                        itemIndexPath = .init(row: itemId+1, section: 0)
                        return true
                    }
                }
                return false
            }
            guard var itemIndexPath = itemIndexPath else {
                return
            }
            itemIndexPath = .init(row: itemIndexPath.row, section: firstIndex ?? itemIndexPath.section)
            
            DispatchQueue.main.async { [weak self] in
                if self?.performersCategories[itemIndexPath.section].isOpened == false{
                    self?.performersCategories[itemIndexPath.section].isOpened = true
                    self?.tableView?.reloadSections([itemIndexPath.section], with: .automatic)
                }
                self?.tableView?.scrollToRow(at: itemIndexPath, at: .top, animated: true)
                //self?.animatedScrollToIndexPath(indexPath: itemIndexPath)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = performersCategories[section]
        
        if category.isOpened{
            return category.subCategories.count + 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard indexPath.row == 0 else {
            let category = performersCategories[indexPath.section].subCategories[indexPath.row-1]
            didSelectCategoryAction?(category.value)
            return
        }
        tableView.beginUpdates()
            performersCategories[indexPath.section].isOpened.toggle()
            var indexPaths: [IndexPath] = []
            
            for itemId in 0..<performersCategories[indexPath.section].subCategories.count{
                let index = IndexPath(row: itemId+1, section: indexPath.section)
                indexPaths.append(index)
            }
        if performersCategories[indexPath.section].isOpened{
            tableView.insertRows(at: indexPaths, with: .automatic)
        } else {
            tableView.deleteRows(at: indexPaths, with: .fade)
        }
        
        tableView.endUpdates()
        tableView.layoutIfNeeded()
        self.animatedScrollToIndexPath(indexPath: indexPath)
    }

    func animatedScrollToIndexPath(indexPath: IndexPath){
        if let rect = self.tableView?.rectForRow(at: indexPath){
            guard let tableView = self.tableView else {
                return
            }
            
            let needPos = rect.minY
            let tableViewHeight = tableView.frame.height
            let contentHeight = tableView.contentSize.height
            var maxPosToScroll = contentHeight - tableViewHeight
            if contentHeight > tableViewHeight {
                if maxPosToScroll < 0 {
                    maxPosToScroll *= -1
                }
            } else{
                maxPosToScroll = 0
            }
            UIView.animate(withDuration: 0.4, delay: 0.1, options: [.beginFromCurrentState,.curveLinear]) {
                if needPos > maxPosToScroll{
                    tableView.contentOffset = .init(x: 0, y: maxPosToScroll)
                } else {
                    tableView.contentOffset = .init(x: 0, y: needPos)
                }
                tableView.layoutIfNeeded()
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        self.tableView = tableView
        return performersCategories.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PerformersCategoryTableViewCell.identifire, for: indexPath)
            if let cell = cell as? PerformersCategoryTableViewCell{
                let category = performersCategories[indexPath.section]
                cell.setText(text: category.name)
                if category.imageAddress.isEmpty == false{
                    if let image = UIImage(named: category.imageAddress){
                        cell.setImage(image: image)
                    }
                }
            }
            cell.selectionStyle = .none
            cell.separatorInset = .init(top: 0, left: tableView.frame.width, bottom: 0, right: 0)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: PerformersCategoriesTableViewDataSourceDelegate.subCategoryCellIdentifire, for: indexPath)
            
            let subCategory = performersCategories[indexPath.section].subCategories[indexPath.row-1]
            if #available(iOS 14.0, *) {
                var contentConfig = UIListContentConfiguration.cell()
                contentConfig.text = subCategory.name
                cell.contentConfiguration = contentConfig
            } else {
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.text = subCategory.name
            }
            cell.indentationWidth = 10
            cell.indentationLevel = 2
            cell.selectionStyle = .default
            cell.separatorInset = .init(top: 0, left: 10, bottom: 0, right: 0)
            if indexPath.row == performersCategories[indexPath.section].subCategories.count{
                cell.separatorInset = .init(top: 0, left: tableView.frame.width, bottom: 0, right: 0)
            }
            return cell
        }
    }
}
