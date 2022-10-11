//
//  OrderInfoPresenter.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 10.10.2022.
//

import Foundation
protocol OrderInfoPresenterDelegate: AnyObject{
    func viewDidLoad()
    func getOrderInfo()
}

class OrderInfoPresenter: OrderInfoPresenterDelegate{
    var interactor: OrderInfoInteractorDelegate
    var workId: String
    var profileMode: ProfileMode = .customer
    weak var router: RouterDelegate?
    weak var viewDelegate: OrderInfoViewDelegate?
    
    init(interactor: OrderInfoInteractorDelegate, workId: String) {
        self.interactor = interactor
        self.workId = workId
    }
    
    func viewDidLoad() {
        getOrderInfo()
    }
    
    func getOrderInfo() {
        if profileMode == .performer{
            interactor.getWorkInfo(workId: workId) {[weak self] orderInfo, apiResponse, error in
                if let orderInfo = orderInfo, let viewDelegate = self?.viewDelegate{
                    if let customer = orderInfo.customer{
                        viewDelegate.setName(name: customer.username.common)
                        viewDelegate.setProfileRating(rating: customer.rating)
                        viewDelegate.setReviewsRating(rating: customer.rating5)
                        viewDelegate.setOrdersCount(count: customer.requests)
#warning("Не хватает данных с апи о количестве отзывов")
                        viewDelegate.setReviewsCount(count: 0)
#warning("Узнать как загружаются изображения заказчика")
                        // interactor.downloadCustomerPhoto(customerId: customer.photo)
                    }
                    
                    if let work = orderInfo.work{
                        viewDelegate.setPrice(price: "\(work.price)")
#warning("Не хватает данных о конфиденциальной информации")
                        viewDelegate.setDetails(details: work.comments)
                        let dateInfo = "\(work.date.start.formattedAsDateTime()) - \(work.date.end.formattedAsDateTime())"
                        viewDelegate.setOrderDate(date: dateInfo)
                        
                        self?.interactor.downloadWorkImages(workId: work.id, imagesId: work.photos) { [weak viewDelegate] imagesData in
                            viewDelegate?.setPhotos(imagesData: imagesData)
                        }
                    }
                }
            }
        } else {
            interactor.getWorkInfoForCustomer(workId: workId) { [weak self, weak viewDelegate] work, apiResponse, error in
                if let work = work{
                    viewDelegate?.setPrice(price: "\(work.price)")
                    viewDelegate?.setDetails(details: work.comments)
                    let dateInfo = "\(work.date.start.formattedAsDateTime()) - \(work.date.end.formattedAsDateTime())"
                    viewDelegate?.setOrderDate(date: dateInfo)
                    
//                    self?.interactor.downloadWorkImages(workId: work.id, imagesId: work.photos) { [weak viewDelegate] imagesData in
//                        viewDelegate?.setPhotos(imagesData: imagesData)
//                    }
                }
            }
        }
    }
}
