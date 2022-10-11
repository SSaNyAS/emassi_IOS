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
    public var imageDownloadAction: ((PerformerForList, _ completion: @escaping (Data?) -> Void) -> Void)?
    public var category: String?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return performers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PerformerTableViewCell.identifire, for: indexPath)
        if let cell = cell as? PerformerTableViewCell{
            let currentPerformer = performers[indexPath.row]
            cell.isSelectingEnabled = false
            cell.nameLabel?.text = currentPerformer.username.common
            imageDownloadAction?(currentPerformer){ [weak photoImageView = cell.photoImageView] imageData in
                DispatchQueue.main.async {
                    photoImageView?.image = UIImage(data: imageData ?? Data()) ?? .noPhotoUser
                }
            }
            cell.didClickOnPerformerAction = { [weak self] in
                self?.didSelectAction?(currentPerformer)
            }
            cell.photoImageView?.image = .noPhotoUser
            cell.ratingView?.rating = currentPerformer.rating
            cell.categoryLabel?.text = category
        }
        return cell
    }
}
