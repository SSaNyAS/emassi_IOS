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
    func uploadPhoto(jpegData:Data,with profileMode: ProfileMode, completion: @escaping (_ message: String?,_ isSuccess: Bool) -> Void)
    func getPhoto(for profileMode: ProfileMode, completion: @escaping (_ imageData: Data?) -> Void)
    func updateProfile(profileMode: ProfileMode, completion: @escaping (_ message: String?,_ isSuccess: Bool) -> Void)
    
    func setUsername(FIO: String)
    func setPhoneNumber(phone: String)
    func setAddress(address: Address)
    func setSupportRegions(supportRegions: [Location])
    func setCategories(categories: [String])
    func setAboutPerformer(aboutText: String)
}

class PerformerProfileInteractor: PerformerProfileInteractorDelegate{
    
    weak var emassiApi: EmassiApi?
    lazy var updatingPerformerData: RequestPerformerProfile = {
        let performerProfile = RequestPerformerProfile(username: Username(common: "", firstname: "", lastname: ""), phonenumber: "", address: Address(), location: [], category: [], comments: "")
        return performerProfile
    }()
    lazy var updatingCustomerData: RequestCustomerProfile = {
        let customerProfile = RequestCustomerProfile(username: .init(common: "", firstname: "", lastname: ""), phonenumber: "", address: .init())
        return customerProfile
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
            let username = Username(common: common, firstname: firstname, lastname: lastname)
            updatingPerformerData.username = username
            updatingCustomerData.username = username
        }
    }
    
    func setPhoneNumber(phone: String) {
        let phoneTrimmed = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        updatingPerformerData.phonenumber = phoneTrimmed
        updatingCustomerData.phonenumber = phoneTrimmed
    }
    
    func setAddress(address: Address) {
        updatingPerformerData.address = address
        updatingCustomerData.address = address
    }
    
    func setSupportRegions(supportRegions: [Location]) {
        updatingPerformerData.location = supportRegions
    }
    
    func setCategories(categories: [String]) {
        updatingPerformerData.category = categories
    }
    
    func setAboutPerformer(aboutText: String) {
        updatingPerformerData.comments = aboutText
    }
    
    func updateProfile(profileMode: ProfileMode, completion: @escaping (_ message: String?,_ isSuccess: Bool) -> Void){
        if profileMode == .performer{
            emassiApi?.updatePerformerProfile(profile: updatingPerformerData, completion: { apiResponse, error in
                completion(error?.localizedDescription ?? apiResponse?.message ?? nil,!(apiResponse?.isErrored ?? true))
            })
        } else {
            emassiApi?.updateCustomerProfile(profile: updatingCustomerData, completion: { apiResponse, error in
                completion(error?.localizedDescription ?? apiResponse?.message ?? nil,!(apiResponse?.isErrored ?? true))
            })
        }
    }
    
    func uploadPhoto(jpegData:Data,with profileMode: ProfileMode, completion: @escaping (_ message: String?,_ isSuccess: Bool) -> Void){
        if profileMode == .performer{
            emassiApi?.uploadPerformerPhoto(photoJpeg: jpegData, completion: { apiResponse, error in
                completion(error?.localizedDescription ?? apiResponse?.message ?? nil,!(apiResponse?.isErrored ?? true))
            })
        } else {
            emassiApi?.uploadCustomerPhoto(photoJpeg: jpegData, completion: { apiResponse, error in
                completion(error?.localizedDescription ?? apiResponse?.message ?? nil,!(apiResponse?.isErrored ?? true))
            })
        }
    }
    
    func getPhoto(for profileMode: ProfileMode,completion: @escaping (_ imageData: Data?) -> Void){
        if profileMode == .performer{
            emassiApi?.downloadPerformerPhotoPublic(completion: { data,_  in
                completion(data)
            })
        } else {
            emassiApi?.downloadCustomerPhotoPublic(completion: { data, _ in
                completion(data)
            })
        }
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
            print("\ncustomerProfile:\n \(String(describing: profile))\n")
        }
        emassiApi?.getPerformerProfile { profile, apiResponse, error in
            print("\nperformerProfile:\n \(String(describing: profile))\n")
        }
    }
    
}
