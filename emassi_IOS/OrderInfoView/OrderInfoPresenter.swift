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
    func workComplete()
    func createRoad()
}

class OrderInfoPresenter: OrderInfoPresenterDelegate{
    var interactor: OrderInfoInteractorDelegate
    var workId: String
    var profileMode: ProfileMode
    weak var router: RouterDelegate?
    weak var viewDelegate: OrderInfoViewDelegate?
    
    init(interactor: OrderInfoInteractorDelegate, workId: String, profileMode: ProfileMode) {
        self.interactor = interactor
        self.workId = workId
        self.profileMode = profileMode
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
                        //viewDelegate.setPhone(phone: customer.phone?.number, confirmed: customer.phone?.confirmed)
                        //viewDelegate.setAddress(address: customer.address?.commonString)
                        #warning("Не хватает данных с апи о количестве отзывов")
                        viewDelegate.setReviewsCount(count: 0)
                        #warning("Узнать как загружаются изображения заказчика")
                        self?.interactor.getCustomerPhoto(photoId: customer.photo, completion: { [weak viewDelegate] imageData, _ in
                            viewDelegate?.setProfileImage(imageData: imageData)
                        })
                    }
                    
                    if let work = orderInfo.work{
                        viewDelegate.setPrice(price: "\(work.price)")
                        #warning("Не хватает данных о конфиденциальной информации")
                        viewDelegate.setDetails(details: work.comments)
                        let dateInfo = "\(work.date.start.formattedAsDateTime()) - \(work.date.end.formattedAsDateTime())"
                        viewDelegate.setOrderDate(date: dateInfo)
                        viewDelegate.setAddress(address: work.address?.commonString)
                        let isVerifiedNumber = (orderInfo.customer?.phone?.confirmed ?? false) && orderInfo.customer?.phone?.number == work.phoneNumber
                        viewDelegate.setPhone(phone: work.phoneNumber, confirmed: isVerifiedNumber)
                        viewDelegate.setEmail(email: nil, confirmed: false)
                        self?.interactor.downloadWorkImages(workId: work.id, imagesId: work.photos) { [weak viewDelegate] imagesData in
                            viewDelegate?.setPhotos(imagesData: imagesData)
                        }
                        
                    }
                }
            }
        } else {
            interactor.getCustomerProfile { [weak viewDelegate, weak self] customerProfile, apiResponse, error in
                if let customer = customerProfile, let viewDelegate = viewDelegate{
                    viewDelegate.setName(name: customer.username.common)
                    viewDelegate.setProfileRating(rating: customer.rating)
                    viewDelegate.setReviewsRating(rating: customer.rating5)
                    viewDelegate.setOrdersCount(count: customer.requests)
                    viewDelegate.setEmail(email: customer.email.address, confirmed: customer.email.confirmed)
                    viewDelegate.setPhone(phone: customer.phone.number, confirmed: customer.phone.confirmed)
                    viewDelegate.setAddress(address: customer.address.commonString)
                    #warning("Не хватает данных с апи о количестве отзывов")
                    //viewDelegate.setReviewsCount(count: 0)
                    self?.interactor.getMyCustomerPhoto {[weak viewDelegate] imageData, _ in
                        viewDelegate?.setProfileImage(imageData: imageData)
                    }
                    
                }
            }
            interactor.getWorkInfoForCustomer(workId: workId) { [weak viewDelegate] work, apiResponse, error in
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
    
    func workComplete() {
        interactor.workComplete(workId: workId) {[weak viewDelegate] apiResponse, error in
            viewDelegate?.showMessage(message: error?.localizedDescription ?? apiResponse?.message ?? "", title: "")
        }
    }
    
    func createRoad() {
        //interactor.createRoute(address: <#T##Address#>)
    }
}
