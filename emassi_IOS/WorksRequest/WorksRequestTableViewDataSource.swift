//
//  WorksRequestTableViewDataSource.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 29.09.2022.
//

import Foundation
import UIKit

class WorksRequestTableViewDataSource:NSObject, UITableViewDataSource{
    var works: [AllWork] = []
    public var addToCalendarAction: ((_ work: AllWork) -> Void)?
    public var sendMessageAction: ((_ work: AllWork) -> Void)?
    public var getCategoryNameAction: ((_ categoryId: String, @escaping (String?) -> Void) -> Void)?
    public var getSuperCategoryNameAction: ((_ categoryId: String, @escaping (String?) -> Void) -> Void)?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return works.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WorksRequestTableViewCell.identifire, for: indexPath)
        if let cell = cell as? WorksRequestTableViewCell{
            let work = works[indexPath.row]
            if work.type == .public{
                cell.orderTypeLabel?.text = "Заявка"
            } else {
                cell.orderTypeLabel?.text = "Вызов"
            }
            
            getCategoryNameAction?(work.category.level2) {[weak self,weak categoryLabel = cell.categoryLabel] categoryName in
                
                if let categoryName = categoryName{
                    DispatchQueue.main.async {
                        categoryLabel?.text = categoryName
                    }
                } else {
                    self?.getSuperCategoryNameAction?(work.category.level1) { [weak categoryLabel] superCategoryName in
                        if let superCategoryName = superCategoryName{
                            DispatchQueue.main.async {
                                categoryLabel?.text = superCategoryName
                            }
                        } else {
                            DispatchQueue.main.async {
                                categoryLabel?.text = work.dateStarted.formattedAsDateTime()
                            }
                        }
                    }
                }
            }
            
            cell.dateLabel?.text = work.offer.date.formattedAsDateTime()
            cell.addressLabel?.text = "address"
            
            cell.createButton(title: "Внести в календарь") { [weak self, work] in
                self?.addToCalendarAction?(work)
            }
            
            cell.createButton(title: "Написать") { [weak self, work] in
                self?.sendMessageAction?(work)
            }
            
        }
        return cell
    }
}
