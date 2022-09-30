//
//  PerformerInfoPresenter.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 23.09.2022.
//

import Foundation
import UIKit.UIImage
protocol PerformerInfoPresenterDelegate: NSObject{
    func viewDidLoad()
    func getPerformerInfo()
}

class PerformerInfoPresenter:NSObject, PerformerInfoPresenterDelegate{
    var interactor: PerformerInfoInteractorDelegate
    var performerId: String
    weak var router: RouterDelegate?
    weak var viewDelegate: PerformerInfoViewDelegate?
    var reviewsDataSource: PerformerReviewsTableViewDataSource = PerformerReviewsTableViewDataSource()
    init(interactor: PerformerInfoInteractorDelegate, performerId: String) {
        self.interactor = interactor
        self.performerId = performerId
    }
    
    func viewDidLoad() {
        
    }
    
    func getPerformerInfo() {
        interactor.getPerformerInfo(performerId: performerId) { [weak self] performer, apiResponse in
            guard let self = self else{ return }
            self.viewDelegate?.setName(name: performer?.username.common)
            self.viewDelegate?.setPhone(phone: performer?.phone.number)
            self.interactor.getPerformerPhoto(performerId: self.performerId) { [weak self] data in
                if let data = data{
                    self?.viewDelegate?.setProfileImage(image: UIImage(data: data))
                }
            }
            self.viewDelegate?.setDescription(description: performer?.comments)
            self.viewDelegate?.setReviewsCount(count: performer?.reviews.count ?? 0)
            self.viewDelegate?.setCompletedOrdersCount(count: performer?.works ?? 0)
            self.viewDelegate?.setReviewsRating(rating: performer?.rating5 ?? 0)
            self.viewDelegate?.setProfileRating(rating: performer?.rating ?? 0)
            self.reviewsDataSource.reviews = performer?.reviews ?? []
            self.viewDelegate?.setReviewsDataSource(dataSource: self.reviewsDataSource)
        }
    }
}
