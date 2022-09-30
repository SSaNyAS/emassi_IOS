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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath)
        let review = reviews[indexPath.row]
        if #available(iOS 14.0, *) {
            var config = UIListContentConfiguration.subtitleCell()
            config.attributedText = NSAttributedString(string: review.customerId,attributes: [.foregroundColor: UIColor.black])
            config.secondaryText = review.text
            cell.contentConfiguration = config
        } else {
            cell.textLabel?.textColor = .black
            cell.textLabel?.text = review.customerId
            cell.detailTextLabel?.text = review.text
        }
        
        return cell
    }
}
