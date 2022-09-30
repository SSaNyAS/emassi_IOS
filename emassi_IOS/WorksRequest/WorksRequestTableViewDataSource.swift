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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return works.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WorksRequestTableViewCell.identifire, for: indexPath)
        if let cell = cell as? WorksRequestTableViewCell{
            let work = works[indexPath.row]
            cell.orderTypeLabel?.text = work.type
            cell.categoryLabel?.text = work.category.level1 + "\r\n" + work.category.level2
            cell.dateLabel?.text = work.dateStarted.description(with: .current)
            cell.addressLabel?.text = work.currency
            
            
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
