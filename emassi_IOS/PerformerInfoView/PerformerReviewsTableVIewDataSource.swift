//
//  PerformerReviewsTableVIewDataSource.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 05.09.2022.
//

import Foundation
import UIKit
class PerformerReviewsTableViewDataSource: NSObject, UITableViewDataSource{
    public var reviews: [Any] = []

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
