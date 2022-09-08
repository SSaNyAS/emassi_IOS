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
            tableView.insertRows(at: indexPaths, with: .bottom)
        } else {
            tableView.deleteRows(at: indexPaths, with: .top)
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
        return 10
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
                cell.setImage(image: UIImage(named: category.imageAddress))
            }
            
            return cell
        } else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            
            let subCategory = performersCategories[indexPath.section].subCategories[indexPath.row-1]
            if #available(iOS 14.0, *) {
                var contentConfig = UIListContentConfiguration.cell()
                contentConfig.text = subCategory.name
                cell.contentConfiguration = contentConfig
            } else {
                cell.textLabel?.text = subCategory.name
            }
            return cell
        }
    }
}
