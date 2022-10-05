//
//  CreateRequestInteractor.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 29.09.2022.
//

import Foundation
import CoreLocation.CLLocation

protocol WorkCreator{
    func setPerformer(performerId: String)
    func setPhone(phone: String?)
    func setLocation(location: Location?)
    func setAddress(address: Address?)
    func setGeoPos(coordinates: CLLocation?)
    func setCategory(category: MoreSelectorItem?)
    func setComments(comments: String?)
    func setDetails(details: String?)
    func setPrice(price: String?)
    func setTime(from: Int, to: Int)
    func setDate(from: Date, to: Date)
}

protocol CreateRequestInteractorDelegate: WorkCreator{
    func getSelectableCategories(completion: @escaping (_ categories: [MoreSelectorItem], _ message: String?) -> Void)
    func createRequest(attachImages: [Data], completion: @escaping (_ apiResponse: EmassiApiResponse?, _ message: String?) -> Void)
    func getCustomerProfile(completion: @escaping (_ profile: CustomerProfile?, _ message: String?) -> Void)
    func uploadWorkPhoto(workId: String,photoJpeg: Data, completion: @escaping (_ apiResponse: EmassiApiResponse?, _ message: String?) -> Void)
}

class CreateRequestInteractor: CreateRequestInteractorDelegate{
    var emassiApi: EmassiApi
    var workCreate: WorkCreate
    var createdWorkId: String? = nil
    
    init(emassiApi: EmassiApi) {
        self.emassiApi = emassiApi
        var location = Location()
        location.ignore = true
        workCreate = .init(category: .init(level1: "", level2: ""), location: location, distance: 0, currency: Locale.current.currencyCode ?? "", address: .init(), geopos: .init(currentCoordinates: .init()), comments: "")
    }
    
    
    func uploadWorkPhoto(workId: String,photoJpeg: Data, completion: @escaping (_ apiResponse: EmassiApiResponse?, _ message: String?) -> Void){
        emassiApi.uploadWorkPhoto(workId: workId, photoJpeg: photoJpeg, completion: { apiResponse, error in
            completion(apiResponse,error?.localizedDescription ?? apiResponse?.message)
        })
    }
    
    func createRequest(attachImages: [Data], completion: @escaping (_ apiResponse: EmassiApiResponse?, _ message: String?) -> Void){
        emassiApi.addNewWork(work: workCreate) {[weak self] workId, apiResponseWorkCreate, errorAddNewWork in
            guard let self = self else {return}
            
            if let workId = workId{
                self.createdWorkId = workId
                completion(apiResponseWorkCreate, errorAddNewWork?.localizedDescription ?? apiResponseWorkCreate?.message)
                for imageData in attachImages{
                    self.emassiApi.uploadWorkPhoto(workId: workId, photoJpeg: imageData) { apiResponse, error in
                        guard error == nil, apiResponse?.isErrored == false else {
                            completion(apiResponse, error?.localizedDescription ?? apiResponse?.message)
                            return
                        }
                    }
                }
            }
        }
    }
    
    func getSuperCategoryForCategory(categoryId: String, completion: @escaping (PerformersCategory?,EmassiApiResponse?,Error?) -> Void){
        emassiApi.getSuperCategory(subCategoryId: categoryId, completion: completion)
    }
    
    func getCustomerProfile(completion: @escaping (_ profile: CustomerProfile?, _ message: String?) -> Void){
        emassiApi.getCustomerProfile(completion: { profile, apiResponse, error in
            completion(profile, error?.localizedDescription ?? apiResponse?.message)
        })
    }
    
    func getSelectableCategories(completion: @escaping (_ categories: [MoreSelectorItem], _ message: String?) -> Void){
        emassiApi.getAllPerformersSubCategories(completion: { subCategories, apiResponse, error in
            let selectableItems = subCategories.map({
                MoreSelectorItem(value: $0.value, name: $0.name)
            })
            completion(selectableItems, error?.localizedDescription ?? apiResponse?.message)
        })
    }
}

extension CreateRequestInteractor: WorkCreator{
    
    func setPerformer(performerId: String) {
        workCreate.performerId = performerId
    }
    
    func setPhone(phone: String?) {
        workCreate.phonenumber = phone ?? ""
    }
    
    func setAddress(address: Address?) {
        if let address = address {
            workCreate.address = address
        }
    }
    
    func setLocation(location: Location?) {
        if var location = location {
            location.ignore = true
            workCreate.location = location
        }
    }
    
    func setGeoPos(coordinates: CLLocation?) {
        if let coordinates = coordinates{
            workCreate.geopos = .init(currentCoordinates: coordinates.coordinate)
        }
    }
    
    func setCategory(category: MoreSelectorItem?) {
        guard let category = category?.value as? String else {
            return
        }
        getSuperCategoryForCategory(categoryId: category) { [weak self] superCategory, _, _ in
            if let superCategory = superCategory{
                self?.workCreate.category = .init(level1: superCategory.value , level2: category)
            } else {
                self?.workCreate.category = .init(level1: category, level2: "")
            }
        }
//        var superCategoryString = ""
//        let superCategoryInt = ((Int(category) ?? 0) / 1000) * 1000
//        if superCategoryInt != 0 {
//            superCategoryString = "\(superCategoryInt)"
//        }
//        workCreate.category = .init(level1: superCategoryString, level2: category)
    }
    
    func setComments(comments: String?) {
        workCreate.comments = comments ?? ""
    }
    
    func setDetails(details: String?) {
        workCreate.details = details ?? ""
    }
    
    func setPrice(price: String?) {
        if price?.isEmpty ?? true{
            workCreate.price = 0
        }
        if let intPrice = Int(price ?? "0"){
            workCreate.price = intPrice
        }
        workCreate.currency = Locale.current.currencyCode ?? ""
    }
    
    func setTime(from: Int, to: Int) {
        workCreate.time = .init(start: from, end: to)
    }
    
    func setDate(from: Date, to: Date) {
        workCreate.date = .init(start: from, end: to)
    }
}
