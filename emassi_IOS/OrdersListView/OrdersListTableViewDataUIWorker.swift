//
//  OrdersListTableViewDataUIWorker.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 05.10.2022.
//

import Foundation
import UIKit

class OrdersListTableViewDataUIWorker: NSObject, UITableViewDelegate, UITableViewDataSource {
    var works: [WorkWithCustomer] = []
    var getCategoryNameAction: ((_ categoryId: String, @escaping (String?) -> Void) -> Void)?
    var getSuperCategoryNameAction: ((_ categoryId: String, @escaping (String?) -> Void) -> Void)?
    var getPerformersForWork: ((_ workId: String, @escaping ([PerformerForWork]) -> Void)->Void)?
    var getPerformerPhoto: ((_ performerId: String, @escaping (Data?) ->Void )->Void)?
    var getCustomerPhoto: ((_ photoId: String, @escaping (Data?) ->Void )->Void)?
    var didSendOfferToWorkAction: ((_ workId: String, @escaping (Bool) -> Void) -> Void)?
    var didClickOnWorkAction: ((_ workId: String) -> Void)?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return works.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PerformerTableViewCell.identifire, for: indexPath)
        
        if let cell = cell as? PerformerTableViewCell{
            let workTuple = works[indexPath.section]
            let work = workTuple.work
            let customer = workTuple.customer
            cell.nameLabel?.text = customer?.username.common
            
            if let work = work, let customer = customer{
                cell.didClickOnPerformerAction = { [weak self] in
                    self?.didClickOnWorkAction?(work.id)
                }
                getCategoryNameAction?(work.category.level2) {[weak self,weak categoryLabel = cell.categoryLabel] categoryName in
                    
                    if let categoryName = categoryName{
                        DispatchQueue.main.async {
                            categoryLabel?.text = categoryName + "\r\n\(work.startDate.formattedAsDateTime())"
                        }
                    } else {
                        self?.getSuperCategoryNameAction?(work.category.level1) { [weak categoryLabel] superCategoryName in
                            if let superCategoryName = superCategoryName{
                                DispatchQueue.main.async {
                                    categoryLabel?.text = superCategoryName + "\r\n\(work.startDate.formattedAsDateTime())"
                                }
                            } else {
                                DispatchQueue.main.async {
                                    categoryLabel?.text = work.startDate.formattedAsDateTime()
                                }
                            }
                        }
                    }
                }
                
                cell.addAcceptButton(title: "Предложить помощь") { [weak self] in
                    self?.didSendOfferToWorkAction?(work.id){ _ in
                        
                    }
                }
                if let myOffer = workTuple.myOfferToWork{
                    if myOffer.isEmpty == false {
                        cell.acceptButton?.isEnabled = false
                        cell.acceptButton?.setTitle("Вы уже откликнулись", for: .normal)
                    }
                }
                let workInfoText = "Стоимость: \(work.price) \(work.currency)\r\nСрок выполнения: \r\n\(work.date.start.formattedAsDateTime()) - \(work.date.end.formattedAsDateTime())\r\n\r\n\(work.comments)"
                cell.setReviewText(text: workInfoText)
                getCustomerPhoto?(customer.photo){[weak imageView = cell.photoImageView] imageData in
                    DispatchQueue.main.async{
                        imageView?.image = UIImage(data: imageData ?? Data()) ?? .noPhotoUser
                    }
                }
                cell.ratingView?.rating = customer.rating
            }
        }
        
        return cell
    }
    
    
}
