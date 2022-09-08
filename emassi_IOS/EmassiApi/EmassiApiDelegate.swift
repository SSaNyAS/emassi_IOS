//
//  EmassiApiDelegate.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 08.09.2022.
//

import Foundation
protocol EmassiApiDelegate{
    
    func getAccoutToken(email: String, password: String)
    func createNewAccount(email: String, password: String, lang: String)
    func changeAccountPassword(email: String, oldPassword: String, newPassword: String)
    func getAccountInfo()
    func deleteAccount()
    func updateDeviceToken()
    func updateGeoPosition()
    
    func getAllPerformers(by category: String)
    func downloadPerformerPhoto(by id_public: String)
    func getPerformerProfile(by id_public: String)
    
    func createUpdateCustomerProfile(by customer: String)
    func getCustomerProfile()
    func uploadCustomerPhoto(photo: Data)
    func downloadCustomerPhoto()
    
    func createUpdatePerformerProfile(by performer: String)
    func getPerformerProfile()
    func uploadPerformerPhoto(photo: Data)
    func downloadPerformerPhoto()
    
    func getAllSelfWork(active: Bool) // used for get orders history
    func getPerformersListForWork(work: String)
    //func downloadPerformerPhoto(by id_public: String)
    func deleteWork(work: String)
    func sendFeedBackForWork(work: String, rating: Int, text: String)
    
    func uploadPerformerDocs(file: Data, type: String, name: String)
    func getPerformerDocs(id: String)
    func deletePerformerDocs(id: String)
    
    func getAllWork(date_start: Int, active: Bool)
    func getWork(workId: String)
    func downloadCustomerPhoto(by id_public: String)
    func getPhotoFromWork(workId: String, photoId: String)
    func sendOfferForWork(workId: String, text: String)
    func acceptCancelPrivateWork(workId: String, action: String)
    func addNewWork(by work: String)
    func addPhotoToWork(workId: String, photo: Data)
    func deletePhotoFromWork(workId: String, photoId: String)
    func sendCustomerFeedBackForWork(workId: String, rating: Int, text: String)
    func sendPerformerFeedBackForWork(workId: String, rating: Int, text: String)
    
}

