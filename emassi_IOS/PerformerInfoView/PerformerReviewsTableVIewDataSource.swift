//
//  PerformerReviewsTableVIewDataSource.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 05.09.2022.
//

import Foundation
import UIKit
class PerformerReviewsTableViewDataSource: NSObject, UITableViewDataSource{
    public var reviews: [Review] = []
    public var maxShowCount: Int = 5
    public var isUseLimitedCount: Bool = true
    static let reuseIdentifire: String = "reviewCell"
    
    var getCustomerAction: ((_ customerId: String, @escaping (Customer?) -> Void) -> Void)?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var totalCount = reviews.count
        if isUseLimitedCount{
            totalCount = totalCount > maxShowCount ? maxShowCount : totalCount
        }
        return totalCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PerformerReviewsTableViewDataSource.reuseIdentifire, for: indexPath)
        let review = reviews[indexPath.row]
        #warning("Сделать отображение отзывов с именем заказчика")
        getCustomerAction?(review.customerId){ [weak cell] customer in
            DispatchQueue.main.async {
                if #available(iOS 14.0, *) {
                    var config = UIListContentConfiguration.subtitleCell()
                    config.attributedText = NSAttributedString(string: customer?.username.firstname ?? "",attributes: [.foregroundColor: UIColor.label])
                    config.secondaryText = review.text
                    cell?.contentConfiguration = config
                } else {
                    cell?.textLabel?.textColor = .label
                    cell?.textLabel?.numberOfLines = 0
                    cell?.detailTextLabel?.numberOfLines = 0
                    cell?.textLabel?.text = customer?.username.firstname
                    cell?.detailTextLabel?.text = review.text
                }
            }
        }
        
        return cell
    }
}
