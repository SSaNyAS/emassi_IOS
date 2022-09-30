//
//  PerformersListDataSourceAndDelegate.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 23.09.2022.
//

import Foundation
import UIKit

class PerformersListDataSourceAndDelegate: NSObject, UITableViewDataSource, UITableViewDelegate{
    public var performers: [PerformerForList] = []
    public var didSelectAction: ((PerformerForList) -> Void)?
    public var category: String?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return performers.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let performer = performers[indexPath.row]
        didSelectAction?(performer)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PerformerTableViewCell.identifire, for: indexPath)
        if let cell = cell as? PerformerTableViewCell{
            let currentPerformer = performers[indexPath.row]
            cell.isSelectingEnabled = false
            cell.nameLabel?.text = currentPerformer.username.common
            cell.photoImageView?.image = .noPhotoUser
            cell.ratingView?.rating = currentPerformer.rating
            cell.categoryLabel?.text = category
        }
        return cell
    }
}
