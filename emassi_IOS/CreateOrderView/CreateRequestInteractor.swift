//
//  CreateRequestInteractor.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 29.09.2022.
//

import Foundation
protocol WorkCreator{
    func setPerformer(performerId: String)
    func setPhone(phone: String?)
    func setAddress(address: Address?)
    func setCategory(category: MoreSelectorItem?)
    func setComments(comments: String?)
    func setDetails(details: String?)
    func setPrice(price: String?)
    func setTime(from: Int, to: Int)
}

protocol CreateRequestInteractorDelegate: WorkCreator{
    func getSelectableCategories(completion: @escaping (_ categories: [MoreSelectorItem], _ message: String?) -> Void)
    func createRequest(attachImages: [Data], completion: @escaping (_ apiResponse: EmassiApiResponse?, _ message: String?) -> Void)
    func getCustomerProfile(completion: @escaping (_ profile: CustomerProfile?, _ message: String?) -> Void)
    func uploadWorkPhoto(workId: String,photoJpeg: Data, completion: @escaping (_ apiResponse: EmassiApiResponse?, _ message: String?) -> Void)
}

class CreateRequestInteractor: CreateRequestInteractorDelegate{
    
    weak var emassiApi: EmassiApi?
    var workCreate: WorkCreate
    
    init(emassiApi: EmassiApi) {
        self.emassiApi = emassiApi
        workCreate = .init(category: .init(level1: "", level2: ""), location: .init(country: Locale.current.languageCode ?? "", state: "", city: ""), distance: 0, currency: Locale.current.currencyCode ?? "", address: .init(country: Locale.current.languageCode ?? "", state: "", city: "", zip: "", line1: "", line2: ""), geopos: .init(currentCoordinates: .init()), comments: "")
    }
    
    
    func uploadWorkPhoto(workId: String,photoJpeg: Data, completion: @escaping (_ apiResponse: EmassiApiResponse?, _ message: String?) -> Void){
        emassiApi?.uploadWorkPhoto(workId: workId, photoJpeg: photoJpeg, completion: { apiResponse, error in
            completion(apiResponse,error?.localizedDescription ?? apiResponse?.message)
        })
    }
    
    func createRequest(attachImages: [Data], completion: @escaping (_ apiResponse: EmassiApiResponse?, _ message: String?) -> Void){
        emassiApi?.addNewWork(work: workCreate, completion: {[weak self] workId, apiResponse, error in
            if !(apiResponse?.isErrored ?? true){
                for imageData in attachImages {
                    if workId == nil {
                        break
                    }
                    self?.uploadWorkPhoto(workId: workId!, photoJpeg: imageData, completion: { apiResponse, message in
                        print(message ?? "")
                    })
                }
            }
            completion(apiResponse,error?.localizedDescription ?? apiResponse?.message)
        })
    }
    
    func getCustomerProfile(completion: @escaping (_ profile: CustomerProfile?, _ message: String?) -> Void){
        emassiApi?.getCustomerProfile(completion: { profile, apiResponse, error in
            completion(profile, error?.localizedDescription ?? apiResponse?.message)
        })
    }
    
    func getSelectableCategories(completion: @escaping (_ categories: [MoreSelectorItem], _ message: String?) -> Void){
        emassiApi?.getAllPerformersSubCategories(completion: { subCategories, apiResponse, error in
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
    
    func setCategory(category: MoreSelectorItem?) {
        guard let category = category?.value as? String else {
            return
        }
        var superCategoryString = ""
        let superCategoryInt = ((Int(category) ?? 0) / 1000) * 1000
        if superCategoryInt != 0 {
            superCategoryString = "\(superCategoryInt)"
        }
        workCreate.category = .init(level1: superCategoryString, level2: category)
    }
    
    func setComments(comments: String?) {
        workCreate.comments = comments ?? ""
    }
    
    func setDetails(details: String?) {
        workCreate.details = details ?? ""
    }
    
    func setPrice(price: String?) {
        if let intPrice = Int(price ?? ""){
            workCreate.price = intPrice
        }
        workCreate.currency = Locale.current.currencyCode ?? ""
    }
    
    func setTime(from: Int, to: Int) {
        workCreate.time = .init(start: from, end: to)
    }
}
