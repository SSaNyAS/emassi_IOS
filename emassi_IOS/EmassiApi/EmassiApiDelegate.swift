//
//  EmassiApiDelegate.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 08.09.2022.
//

import Foundation
import Network
import CryptoKit

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

protocol EmassiApiAuthorizationDelegate{
    var apiKey: String { get }
    static var token: String { get }
    
    func getAccountToken(email: String, password: String, completion: (Result<String,Error>)->Void)
    func computeSign(email:String, password:String) -> String
}

class EmassiApi: EmassiApiFetcher{
    let hostUrl = URL(string: "https://test.emassi.app")
    
    lazy var getAccountToken: EmassiRequestInfo = {
        EmassiRequestInfo(address: "/api/v1/account", method: .get, attachHttpHeaders: ["apiKey": apiKey])
    }()
    let createAccount = EmassiRequestInfo(address: "/api/v1/account", method: .post)
    
    override init(apiKey: String,skey: String) {
        super.init(apiKey: apiKey,skey: skey)
        
    }
    
    func getAccountToken(email: String, password: String, completion: @escaping (Data?,URLResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/account", relativeTo: hostUrl) else {return}
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 30)
        request.httpMethod = URLRequest.HTTPMethod.get.rawValue
        let sign = computeSign(email: email, password: password)
        request.addValue(sign, forHTTPHeaderField: "sign")
        dataFetchURLSession.dataTask(with: request, completionHandler: completion).resume()
    }
    
    func baseDataRequest(requestInfo: EmassiRequestInfo, completion: @escaping (Data?, URLResponse?, Error?)-> Void){
        guard let url = URL(string: requestInfo.address,relativeTo: hostUrl) else {return}
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 30)
        urlRequest.httpMethod = getAccountToken.method.rawValue
        
        let dataTask = dataFetchURLSession.dataTask(with: urlRequest, completionHandler: completion)
        dataTask.resume()
    }
    func computeSign(email: String, password: String) -> String{
        let codingString = email.trimmingCharacters(in: .whitespacesAndNewlines)+password.trimmingCharacters(in: .whitespacesAndNewlines)
        let sha256 = codingString.sha256()
        guard let sha256Data = sha256.data(using: .utf8) else {return ""}
        guard let sKeyData = skey.data(using: .utf8) else {return ""}
        let hmac = HMAC<SHA256>.authenticationCode(for: sha256Data, using: .init(data: sKeyData))
        return hmac.description
    }
}

struct EmassiRequestInfo {
    let address: String
    let method: URLRequest.HTTPMethod
    var attachHttpHeaders: [String:String]?
    var queryParams: [URLQueryItem]?
    var httpBody: Data?
}
