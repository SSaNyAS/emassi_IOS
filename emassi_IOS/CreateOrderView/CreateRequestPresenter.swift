//
//  CreateRequestPresenter.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 29.09.2022.
//

import Foundation
protocol CreateRequestPresenterDelegate{
    func viewDidLoad()
    func createRequest()
    func addPhoto()
    
    func setPerformer(performerId: String)
    func setPhone(phone: String?)
    func setCategory(category: MoreSelectorItem?)
    func setComments(comments: String?)
    func setDetails(details: String?)
    func setPrice(price: String?)
    func setTime(from: Int, to: Int)
}

class CreateRequestPresenter: CreateRequestPresenterDelegate{
    var interactor: CreateRequestInteractorDelegate & WorkCreator
    weak var router: RouterDelegate?
    weak var viewDelegate: CreateRequestViewDelegate?
    var imagesToRequest: [Data] = []
    var performerId: String
    
    init(interactor: CreateRequestInteractorDelegate & WorkCreator, performerId:  String) {
        self.interactor = interactor
        self.performerId = performerId
    }
    
    func createRequest() {
        interactor.createRequest(attachImages: imagesToRequest) { [weak self] apiResponse, message in
            if let message = message{
                self?.viewDelegate?.showMessage(message: message, title: "")
            }
            
            if let viewController = self?.viewDelegate?.getViewController(){
                self?.router?.goToViewController(from: viewController, to: .categories, presentationMode: .pop)
            }
        }
    }
    
    func selectAddress(currentText: String?){
        if let viewController = viewDelegate?.getViewController(){
            router?.goToViewController(from: viewController, to: .addressSelector(currentText, { [weak self] address in
                self?.setAddress(address: address)
            }), presentationMode: .present)
        }
    }
    
    func addPhoto() {
        if let viewController = viewDelegate?.getViewController(){
            router?.goToViewController(from: viewController, to: .imagePicker({[weak self] image in
                guard let self = self else {return}
                if let data = image.compressedData(){
                    self.imagesToRequest.append(data)
                }
            }, nil), presentationMode: .present)
        }
    }
    
    func viewDidLoad() {
        interactor.getSelectableCategories {[weak self] categories, message in
            self?.viewDelegate?.setSelectableCategories(categories: categories)
        }
        interactor.getCustomerProfile {[weak self] profile, message in
            if let profile = profile{
                self?.viewDelegate?.setAddress(address: profile.address.city)
            }
        }
        setPerformer(performerId: performerId)
    }
}

extension CreateRequestPresenter: WorkCreator{
    func setPerformer(performerId: String) {
        interactor.setPerformer(performerId: performerId)
    }
    
    func setPhone(phone: String?) {
        interactor.setPhone(phone: phone)
    }
    
    func setAddress(address: Address?) {
        interactor.setAddress(address: address)
        viewDelegate?.setAddress(address: address?.commonString ?? "")
    }
    
    func setCategory(category: MoreSelectorItem?) {
        interactor.setCategory(category: category)
    }
    
    func setComments(comments: String?) {
        interactor.setComments(comments: comments)
    }
    
    func setDetails(details: String?) {
        interactor.setDetails(details: details)
    }
    
    func setPrice(price: String?) {
        interactor.setPrice(price: price)
    }
    
    func setTime(from: Int, to: Int) {
        interactor.setTime(from: from, to: to)
    }
    
    
}
