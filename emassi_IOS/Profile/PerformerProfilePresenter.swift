//
//  PerformerProfilePresenter.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 25.09.2022.
//

import Foundation
protocol PerformerProfilePresenterDelegate: AnyObject{
    func viewDidLoad()
    func pickImage()
    func selectAddress(currentValue: String?)

    func setUsername(FIO: String)
    func setPhoneNumber(phone: String)
    func setAddress(address: Address)
    func setSupportRegions(supportRegions: [MoreSelectorItem])
    func setCategories(categories: [MoreSelectorItem])
    func setAboutPerformer(aboutText: String)
    func saveClick()
}

class PerformerProfilePresenter{
    var interactor: PerformerProfileInteractorDelegate
    weak var viewDelegate: PerformerProfileViewDelegate?
    weak var router: RouterDelegate?
    
    init(interactor: PerformerProfileInteractorDelegate) {
        self.interactor = interactor
    }
}

extension PerformerProfilePresenter: PerformerProfilePresenterDelegate{
    func setSupportRegions(supportRegions: [MoreSelectorItem]) {
        let supportRegionsAsLocation = supportRegions.compactMap({
            $0.value as? LocationPerformer
        })
        setSupportRegions(supportRegions: supportRegionsAsLocation)
    }
    
    func setCategories(categories: [MoreSelectorItem]) {
        let categoryStringList = categories.compactMap({
            $0.value as? String
        })
        self.setCategories(categories: categoryStringList)
    }
    
    func saveClick() {
        interactor.updateProfile {[weak self] message, isSuccess in
            self?.viewDelegate?.showMessage(message: message ?? "", title: "")
        }
    }
    func selectAddress(currentValue: String? = nil) {
        if let viewController = self.viewDelegate?.getViewController(){
            router?.goToViewController(from: viewController, to: .addressSelector(currentValue,{ [weak self] address in
                self?.setAddress(address: address)
            }), presentationMode: .present)
        }
    }
    
    
    func setUsername(FIO: String) {
        interactor.setUsername(FIO: FIO)
        viewDelegate?.setName(name: FIO)
    }
    
    func setPhoneNumber(phone: String) {
        interactor.setPhoneNumber(phone: phone)
        viewDelegate?.setPhone(phone: phone)
    }
    
    func setAddress(address: Address) {
        interactor.setAddress(address: address)
        viewDelegate?.setAddress(address: address.commonString)
    }
    
    func setSupportRegions(supportRegions: [LocationPerformer]) {
        interactor.setSupportRegions(supportRegions: supportRegions)
        let mapped  = supportRegions.map({
            MoreSelectorItem(value: $0, name: $0.common)
        })
        viewDelegate?.setSupportRegions(regions: mapped)
    }
    
    func setCategories(categories: [String]) {
        interactor.setCategories(categories: categories)
        viewDelegate?.setSelectedCategoryList(categories: categories)
    }
    
    func setAboutPerformer(aboutText: String) {
        interactor.setAboutPerformer(aboutText: aboutText)
        viewDelegate?.setAboutPeformer(aboutText: aboutText)
    }
    
    func viewDidLoad() {
        interactor.getPerformerProfile { [weak self] profile, message in
            if profile == nil {
                self?.viewDelegate?.showMessage(message: message ?? "", title: "")
            } else {
                guard let profile = profile, let self = self else {
                    return
                }
                self.setUsername(FIO: profile.username.common)
                self.setPhoneNumber(phone: profile.phone.number)
                self.viewDelegate?.setProfileRating(rating: profile.rating)
                self.viewDelegate?.setReviewsRating(rating: profile.rating5)
                self.viewDelegate?.setOrdersCount(count: profile.works)
                self.setAboutPerformer(aboutText: profile.comments)
                self.setAddress(address: profile.address)
                self.interactor.getPerformerPhoto { [weak self] imageData in
                    self?.viewDelegate?.setProfileImage(imageData: imageData)
                }
                
                let supportRegions =  profile.location.map({
                    MoreSelectorItem(value: $0.city, name: $0.city)
                })
                
                self.viewDelegate?.setSupportRegions(regions: supportRegions)
                
                let selectedCategories = profile.category
                
                self.interactor.getCategoryList { [weak self] categories in
                    let mapped = categories.map { category in
                        MoreSelectorItem(value: category.value, name: category.name)
                    }
                    self?.viewDelegate?.setCategoryList(categories: mapped)
                    self?.viewDelegate?.setSelectedCategoryList(categories: selectedCategories)
                }
            }
        }
    }
    
    func pickImage() {
        if let viewController = viewDelegate?.getViewController(){
            router?.goToViewController(from: viewController, to: .imagePicker({ [weak self] image in
                if let data = image.resizeImage(targetSize: .init(width: 200, height: 240))?.jpegData(compressionQuality: 0.8){
                    self?.interactor.uploadPhoto(jpegData: data, completion: {[weak self] message, isSuccess in
                        if !isSuccess{
                            self?.viewDelegate?.showMessage(message: message ?? "", title: "")
                        } else{
                            self?.viewDelegate?.setProfileImage(imageData: data)
                        }
                    })
                }
            }, nil), presentationMode: .present)
        }
    }
    
    func uploadPhoto(jpegData: Data) {
        interactor.uploadPhoto(jpegData: jpegData) {[weak self] message, isSuccess in
            if !isSuccess{
                self?.viewDelegate?.showMessage(message: message ?? "", title: "")
            }
        }
    }
}
