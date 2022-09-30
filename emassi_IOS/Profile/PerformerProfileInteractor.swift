//
//  PerformerProfileInteractor.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 25.09.2022.
//

import Foundation
protocol PerformerProfileInteractorDelegate{
    func getPerformerProfile(completion: @escaping (_ profile: PerformerProfile?,_ message: String?) -> Void)
    func getCategoryList(completion: @escaping (_ categories: [PerformersSubCategory]) -> Void)
    func uploadPhoto(jpegData:Data, completion: @escaping (_ message: String?,_ isSuccess: Bool) -> Void)
    func getPerformerPhoto(completion: @escaping (_ imageData: Data?) -> Void)
    func updateProfile(completion: @escaping (_ message: String?,_ isSuccess: Bool) -> Void)
    
    func setUsername(FIO: String)
    func setPhoneNumber(phone: String)
    func setAddress(address: String)
    func setSupportRegions(supportRegions: [String])
    func setCategories(categories: [String])
    func setAboutPerformer(aboutText: String)
}

class PerformerProfileInteractor: PerformerProfileInteractorDelegate{
    
    weak var emassiApi: EmassiApi?
    lazy var updatingRerformerData: RequestPerformerProfile = {
        let performerProfile = RequestPerformerProfile(username: .init(common: "", firstname: "", lastname: ""), phonenumber: "", address: .init(country: "", state: "", city: "", zip: "", line1: "", line2: ""), location: [], category: [], comments: "")
        return performerProfile
    }()
    
    init(emassiApi: EmassiApi) {
        self.emassiApi = emassiApi
    }
    
    func setUsername(FIO: String) {
        let common = FIO.trimmingCharacters(in: .whitespacesAndNewlines)
        let components = common.split(separator: " ")
        if components.count == 2 || components.count == 3{
            let firstname = String(components[1])
            let lastname = String(components[0])
            updatingRerformerData.username = .init(common: common, firstname: firstname, lastname: lastname)
        }
    }
    
    func setPhoneNumber(phone: String) {
        let phoneTrimmed = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        updatingRerformerData.phonenumber = phoneTrimmed
    }
    
    func setAddress(address: String) {
        let common = address.trimmingCharacters(in: .whitespacesAndNewlines)
        var components = common.split(separator: ",")
        var country = updatingRerformerData.address.country
        var city = updatingRerformerData.address.city
        var other = updatingRerformerData.address.line1
        if components.count > 0 {
            country = String(components.first ?? "")
            if components.count > 1{
                city = String(components[1])
            }
            if components.count > 2 {
                components.remove(at: 0)
                components.remove(at: 1)
                other = String(components.joined(separator: ", "))
            }
        }
        updatingRerformerData.address = .init(country: country, state: "", city: city, zip: "", line1: other, line2: "")
            
    }
    
    func setSupportRegions(supportRegions: [String]) {
        updatingRerformerData.location = supportRegions.compactMap({
            try? LocationPerformer.init(from: $0)
        })
    }
    
    func setCategories(categories: [String]) {
        updatingRerformerData.category = categories
    }
    
    func setAboutPerformer(aboutText: String) {
        updatingRerformerData.comments = aboutText
    }
    
    func updateProfile(completion: @escaping (_ message: String?,_ isSuccess: Bool) -> Void){
        emassiApi?.updatePerformerProfile(profile: updatingRerformerData, completion: { apiResponse, error in
            completion(error?.localizedDescription ?? apiResponse?.message ?? nil,!(apiResponse?.isErrored ?? true))
        })
    }
    
    func uploadPhoto(jpegData:Data, completion: @escaping (_ message: String?,_ isSuccess: Bool) -> Void){
        emassiApi?.uploadPerformerPhoto(photoJpeg: jpegData, completion: { apiResponse, error in
            completion(error?.localizedDescription ?? apiResponse?.message ?? nil,!(apiResponse?.isErrored ?? true))
        })
    }
    
    func getPerformerPhoto(completion: @escaping (_ imageData: Data?) -> Void){
        emassiApi?.downloadPerformerPhotoPublic(completion: { data,_  in
            completion(data)
        })
    }
    
    func getCategoryList(completion: @escaping (_ categories: [PerformersSubCategory]) -> Void){
        emassiApi?.getAllPerformersSubCategories(completion: { subCategories, apiResponse, error in
            completion(subCategories)
        })
    }
    
    func getPerformerProfile(completion: @escaping (_ profile: PerformerProfile?,_ message: String?) -> Void){
        emassiApi?.getPerformerProfile(completion: { profile, apiResponse, error in
            completion(profile,error?.localizedDescription ?? apiResponse?.message ?? nil)
        })
        emassiApi?.getCustomerProfile { profile, apiResponse, error in
            print("\ncustomerProfile:\n \(profile)\n")
        }
        emassiApi?.getPerformerProfile { profile, apiResponse, error in
            print("\nperformerProfile:\n \(profile)\n")
        }
    }
    
}
