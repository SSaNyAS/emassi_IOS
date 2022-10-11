//
//  CreateRequestPresenter.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 29.09.2022.
//

import Foundation
import CoreLocation.CLLocation

protocol CreateRequestPresenterDelegate{
    func viewDidLoad()
    func createRequest()
    func selectLocalizationAddress(currentText: String?)
    func selectCallAddress(currentText: String?)
    func addPhoto()
    
    func setPerformer(performerId: String)
    func setPhone(phone: String?)
    func setCategory(category: MoreSelectorItem?)
    func setComments(comments: String?)
    func setDetails(details: String?)
    func setPrice(price: String?)
    func setDate(from: Date?, to: Date?)
    func setTime(from: Int, to: Int)
}

class CreateRequestPresenter: CreateRequestPresenterDelegate{
    var interactor: CreateRequestInteractorDelegate & WorkCreator
    weak var router: RouterDelegate?
    weak var viewDelegate: CreateRequestViewDelegate?
    var imagesToRequest: [Data] = []
    var performerId: String
    var selectedCategory: String?
    
    init(interactor: CreateRequestInteractorDelegate & WorkCreator, performerId:  String) {
        self.interactor = interactor
        self.performerId = performerId
    }
    
    func createRequest() {
        interactor.createRequest { [weak self] workId, apiResponse, message in
            if (apiResponse?.isErrored ?? true){
                self?.viewDelegate?.showMessage(message: message ?? "", title: "")
            } else {
                guard let workId = workId else {
                    return
                }
                self?.interactor.uploadWorkPhotos(workId: workId, photosJpeg: self?.imagesToRequest ?? []) { [weak self] isSuccess in
                    if isSuccess {
                        if let viewController = self?.viewDelegate?.getViewController(){
                            DispatchQueue.main.async {
                                viewController.dismiss(animated: true)
                            }
                        }
                    } else{
                        self?.viewDelegate?.showMessage(message: "Ошибка отправки изображений", title: "")
                    }
                }
                
            }
        }
    }
    
    func selectLocalizationAddress(currentText: String?){
        if let viewController = viewDelegate?.getViewController(){
            router?.goToViewController(from: viewController, to: .addressSelector(currentText, { [weak self] address, coordinate in
                self?.setLocation(location: Location(from: address))
            }), presentationMode: .present)
        }
    }
    
    func selectCallAddress(currentText: String?){
        if let viewController = viewDelegate?.getViewController(){
            router?.goToViewController(from: viewController, to: .addressSelector(currentText, { [weak self] address, coordinate in
                self?.setAddress(address: address)
                self?.setGeoPos(coordinates: coordinate)
            }), presentationMode: .present)
        }
    }
    
    func addPhoto() {
        if let viewController = viewDelegate?.getViewController(){
            router?.goToViewController(from: viewController, to: .imagePicker({[weak self] image in
                guard let self = self else {return}
                if let data = image.compressedData(){
                    self.imagesToRequest.append(data)
                    self.viewDelegate?.addPhoto(imageData: data)
                }
            }, nil), presentationMode: .present)
        }
    }
    
    func viewDidLoad() {
        interactor.getSelectableCategories {[weak self] categories, message in
            self?.viewDelegate?.setSelectableCategories(categories: categories)
            if let category = self?.selectedCategory{
                if let selectedCategory = categories.first(where: {($0.value as? String) == category}){
                    self?.viewDelegate?.setSelectedCategory(category: selectedCategory)
                }
            }
        }
        interactor.getCustomerProfile {[weak self] profile, message in
            if let profile = profile{
                self?.setAddress(address: profile.address)
                self?.viewDelegate?.setPhone(phone: profile.phone.number)
                self?.setPhone(phone: profile.phone.number)
            }
        }
        
        setPerformer(performerId: performerId)
    }
}

extension CreateRequestPresenter: WorkCreator {
    func setPerformer(performerId: String) {
        interactor.setPerformer(performerId: performerId)
    }
    
    func setPhone(phone: String?) {
        interactor.setPhone(phone: phone)
    }
    
    func setLocation(location: Location?){
        interactor.setLocation(location: location)
        viewDelegate?.setLocalizationAddress(address: location?.common ?? "")
    }
    
    func setAddress(address: Address?) {
        interactor.setAddress(address: address)
        viewDelegate?.setCallAddress(address: address?.commonString ?? "")
    }
    
    func setGeoPos(coordinates: CLLocation?) {
        interactor.setGeoPos(coordinates: coordinates)
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
        guard from >= 0 && from <= 24 && to >= 0 && to <= 24 else {
            viewDelegate?.showMessage(message: "Время должно быть в пределах от 0 до 24 часов", title: "")
            return
        }

        interactor.setTime(from: from, to: to)
    }
    
    func setDate(from: Date, to: Date) {
        interactor.setDate(from: from.addingTimeInterval(60), to: to)
    }
    
    func setDate(from: Date?, to: Date?) {
        guard var from = from, let to = to else {
            viewDelegate?.showMessage(message: "Укажите дату", title: "")
            return
        }
        
        if from < Date(){
            from = Date()
            viewDelegate?.setMinimumDate()
        }
        
        self.setDate(from: from, to: to)
    }
}
