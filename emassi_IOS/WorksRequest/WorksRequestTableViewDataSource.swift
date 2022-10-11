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
    public var sendWorkStatus: ((_ workId: String, WorkStatus, _ completion: @escaping (Bool) -> Void) -> Void)?
    public var didSelectWork: ((_ workId: String) -> Void)?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return works.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WorksRequestTableViewCell.identifire, for: indexPath)
        if let cell = cell as? WorksRequestTableViewCell{
            let work = works[indexPath.row]
            if work.type == .public{
                cell.orderTypeLabel?.text = "Заявка"
                cell.createButton(title: "Внести в календарь") { [weak self, work] in
                    self?.addToCalendarAction?(work)
                }
                
                cell.createButton(title: "Написать") { [weak self, work] in
                    self?.sendMessageAction?(work)
                }
            } else {
                cell.orderTypeLabel?.text = "Вызов"
                cell.createButton(title: "Отказаться") { [weak self] in
                    self?.sendWorkStatus?(work.id, WorkStatus.cancel){ isSuccess in
                        
                    }
                }
                
                cell.createButton(title: "Принять") { [weak self] in
                    self?.sendWorkStatus?(work.id, WorkStatus.accept){ isSuccess in
                        
                    }
                }
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
            let workPeriod = "\(work.date.start.formattedAsDateTime()) - \(work.date.end.formattedAsDateTime())"
            cell.dateLabel?.text = workPeriod
            cell.addressLabel?.text = work.comments
            cell.didSelectAction = { [weak self] in
                self?.didSelectWork?(work.id)
            }
        }
        return cell
    }
}
