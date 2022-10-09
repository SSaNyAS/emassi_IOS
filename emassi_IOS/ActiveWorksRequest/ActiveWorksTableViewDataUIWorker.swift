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
    var didAcceptPerformerAction: ((_ workId: String, String) -> Void)?
    var didDenyPerformerAction: ((_ workId: String, String) -> Void)?
    var didSendMessageToPerformerAction: ((_ workId: String, String) -> Void)?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return works[section].performersList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return works.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let activeWorksHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ActiveWorksHeaderView.identifire) as? ActiveWorksHeaderView
        let currentWork = works[section]
        if let activeWorksHeaderView = activeWorksHeaderView{
            activeWorksHeaderView.didCancelWorkAction = { [weak self] in
                self?.didCancelWorkAction?(currentWork.workId, { [weak self] isSuccess in
                    if isSuccess{
                        DispatchQueue.main.async {
                            tableView.beginUpdates()
                            self?.works.remove(at: section)
                            tableView.endUpdates()
                        }
                    }
                })
            }
            
            getCategoryNameAction?(currentWork.category.level2){ [weak categoryLabel = activeWorksHeaderView.categoryLabel, weak activeWorksHeaderView] categoryName in
                categoryLabel?.text = categoryName
                activeWorksHeaderView?.invalidateIntrinsicContentSize()
            }
            activeWorksHeaderView.commentsTextLabel?.text = currentWork.comments
            activeWorksHeaderView.commentsTextLabel?.invalidateIntrinsicContentSize()
            activeWorksHeaderView.dateTimeLabel?.text = currentWork.dateStarted.formattedAsDateTime()
        }
        activeWorksHeaderView?.layoutIfNeeded()
        return activeWorksHeaderView
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PerformerTableViewCell.identifire, for: indexPath)
        
        if let cell = cell as? PerformerTableViewCell{
            let work = works[indexPath.section]
            let performer = work.performersList[indexPath.row]
            cell.nameLabel?.text = performer.username.common
            cell.categoryLabel?.text = performer.offer.date.formattedAsDateTime()
            
            getPerformerPhoto?(performer.id){[weak imageView = cell.photoImageView] imageData in
                DispatchQueue.main.async {
                    imageView?.image = UIImage(data: imageData ?? Data()) ?? .noPhotoUser
                }
            }
            cell.addSendMessageButton { [weak self] in
                self?.didSendMessageToPerformerAction?(work.workId, performer.id)
            }
            if work.performerId == performer.id{
                cell.categoryLabel?.text = "Выбранный исполнитель"
                cell.addCallButton {
                    if let url = URL(string: "tel:\\+79328487228"){
                        if UIApplication.shared.canOpenURL(url){
                            UIApplication.shared.open(url)
                        }
                    }
                }
            } else if work.performerId.isEmpty {
                cell.addAcceptButton{ [weak self] in
                    self?.didAcceptPerformerAction?(work.workId, performer.id)
                }
            }
            cell.ratingView?.rating = performer.rating5
            let offerText = performer.offer.text.trimmingCharacters(in: .whitespacesAndNewlines)
            if offerText.isEmpty == false{
                cell.setReviewText(text: offerText)
            }
        }
        
        return cell
    }
    
    
}
