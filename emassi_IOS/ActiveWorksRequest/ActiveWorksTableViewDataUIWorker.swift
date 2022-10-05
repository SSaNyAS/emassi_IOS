//
//  ActiveWorksTableViewDataUIWorker.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 04.10.2022.
//

import UIKit

class ActiveWorksTableViewDataUIWorker: NSObject, UITableViewDelegate, UITableViewDataSource {
    var works: [WorkActive] = []
    var getCategoryNameAction: ((_ categoryId: String, @escaping (String?) -> Void) -> Void)?
    var getPerformersForWork: ((_ workId: String, @escaping ([PerformerForWork]) -> Void)->Void)?
    var getPerformerPhoto: ((_ performerId: String, @escaping (Data?) ->Void )->Void)?
    var didCancelWorkAction: ((_ workId: String, @escaping (Bool) -> Void) -> Void)?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return works[section].performersList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return works.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let activeWorksHeaderView = ActiveWorksHeaderView()
        //activeWorksHeaderView.translatesAutoresizingMaskIntoConstraints = false
        //activeWorksHeaderView.widthAnchor.constraint(equalToConstant: tableView.frame.width).isActive = true
        return activeWorksHeaderView
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let currentWork = works[section]
        if let view = view as? ActiveWorksHeaderView{
            
            view.didCancelWorkAction = { [weak self] in
                self?.didCancelWorkAction?(currentWork.workId, { [weak self] isSuccess in
                    tableView.beginUpdates()
                    self?.works.remove(at: section)
                    tableView.endUpdates()
                })
            }
            
            getCategoryNameAction?(currentWork.category.level2){ [weak categoryLabel = view.categoryLabel] categoryName in
                categoryLabel?.text = categoryName
            }
            view.commentsTextView?.text = currentWork.comments
            view.dateTimeLabel?.text = currentWork.dateStarted.formattedAsDateTime()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.noIntrinsicMetric
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PerformerTableViewCell.identifire, for: indexPath)
        
        if let cell = cell as? PerformerTableViewCell{
            let work = works[indexPath.section]
            let performer = work.performersList[indexPath.row]
            cell.nameLabel?.text = performer.username.common
            cell.categoryLabel?.text = performer.offer.date.formattedAsDateTime()
            
            getPerformerPhoto?(performer.id){[weak imageView = cell.photoImageView] imageData in
                imageView?.image = UIImage(data: imageData ?? Data()) ?? .noPhotoUser
            }
            cell.ratingView?.rating = performer.rating5
            cell.setReviewText(text: performer.offer.text)
        }
        
        return cell
    }
    
    
}
