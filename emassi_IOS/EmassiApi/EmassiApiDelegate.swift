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

class EmassiApi: EmassiApiFetcher{
    let hostUrl = URL(string: "https://test.emassi.app")

    var token: String?{
        get{
            SessionConfiguration.Token
        }
        set{
            SessionConfiguration.Token = newValue
        }
    }
    
    public var isValidToken: Bool{
        return token != nil && (token?.isEmpty ?? true) == false
    }
    
    private lazy var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.secondsSince1970
        return decoder
    }()
    
    private lazy var jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = JSONEncoder.DateEncodingStrategy.secondsSince1970
        return encoder
    }()
    
    override init(apiKey: String,skey: String) {
        super.init(apiKey: apiKey,skey: skey)
    }
    
    func updateDeviceToken(deviceToken: String, completion: @escaping (EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/account/\(token ?? "")/device",relativeTo: hostUrl) else{
            completion(nil,nil)
            return
        }
        
        let bodyString = """
            {
                "device_token": "\(deviceToken)"
            }
        """
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyString.data(using: .utf8)
        
        let task = baseDataRequest(request: request, completion: completion)
        task.resume()
    }
    
    func getGeoIPLocation(completion: @escaping (Location?,EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/account/geoip",relativeTo: hostUrl) else{
            completion(nil,nil,nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = baseDataRequest(request: request){ [weak self] apiResponse, error in
            if let data = apiResponse?.data{
                let geoPos = try? self?.jsonDecoder.decode(Location.self, from: data)
                completion(geoPos,apiResponse,error)
                return
            }
            completion(nil,apiResponse,error)
        }
        task.resume()
    }
    
    func sendOffer(workId: String, text: String, completion: @escaping (EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/performer/\(token ?? "")/work/\(workId)/offer",relativeTo: hostUrl) else{
            completion(nil,nil)
            return
        }
        
        let bodyString = """
            {
                "text": "\(text)"
            }
        """
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyString.data(using: .utf8)
        
        let task = baseDataRequest(request: request, completion: completion)
        task.resume()
    }
    
    func sendCustomerFeedback(workId: String, rating: Float, text: String, completion: @escaping (EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/customer/\(token ?? "")/work/\(workId)/feedback",relativeTo: hostUrl) else{
            completion(nil,nil)
            return
        }
        
        let bodyString = """
            {
                "rating": "\(rating)",
                "text": "\(text)"
            }
        """
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyString.data(using: .utf8)
        
        let task = baseDataRequest(request: request, completion: completion)
        task.resume()
    }
    
    func deleteCompletedWorkPerformer(workId: String, completion: @escaping (EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/performer/\(token ?? "")/work/\(workId)",relativeTo: hostUrl) else{
            completion(nil,nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = baseDataRequest(request: request, completion: completion)
        task.resume()
    }
    
    func acceptPerformerForWork(workId: String, performerId: String, completion: @escaping (EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/customer/\(token ?? "")/work/\(workId)",relativeTo: hostUrl) else{
            completion(nil,nil)
            return
        }
        let bodyString = "{ \"id_performer\": \"\(performerId)\" }"
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyString.data(using: .utf8)
        
        let task = baseDataRequest(request: request,completion: completion)
        task.resume()
    }
    
    func changeWorkStatus(workId: String, action: String, completion: @escaping (EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/performer/\(token ?? "")/work/\(workId)",relativeTo: hostUrl) else{
            completion(nil,nil)
            return
        }
        let bodyString = "{ \"action\": \"\(action)\" }"
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyString.data(using: .utf8)
        
        let task = baseDataRequest(request: request,completion: completion)
        task.resume()
    }
    
    func getWork(workId: String,  completion: @escaping (WorkRequest?,EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/performer/\(token ?? "")/work/\(workId)",relativeTo: hostUrl) else{
            completion(nil,nil,nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = baseDataRequest(request: request){ [weak self] apiResponse, error in
            if let data = apiResponse?.data{
                let work = try? self?.jsonDecoder.decode(WorkRequest.self, from: data)
                completion(work,apiResponse,error)
                return
            }
            completion(nil,apiResponse,error)
        }
        task.resume()
    }
    
    func getAllWorks(active: Bool, type: String, startDate: Date? = nil, completion: @escaping ([AllWork]?,EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/performer/\(token ?? "")/work",relativeTo: hostUrl) else{
            completion(nil,nil,nil)
            return
        }
        let startDateIntervalEncoded = try? jsonEncoder.encode(startDate)
        let startDateInterval = startDateIntervalEncoded == nil ? "0" : String(data: startDateIntervalEncoded!, encoding: .utf8) ?? "0"
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("\(active)", forHTTPHeaderField: "active")
        request.addValue(type, forHTTPHeaderField: "type")
        request.addValue("\(startDateInterval)", forHTTPHeaderField: "dt_start")
        
        let task = baseDataRequest(request: request){ [weak self] apiResponse, error in
            if let data = apiResponse?.data{
                let performerProfile = try? self?.jsonDecoder.decode([AllWork].self, from: data)
                completion(performerProfile,apiResponse,error)
                return
            }
            completion(nil,apiResponse,error)
        }
        task.resume()
    }
    
    func getPerformerProfile(completion: @escaping (PerformerProfile?,EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/performer/\(token ?? "")",relativeTo: hostUrl) else{
            completion(nil,nil,nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = baseDataRequest(request: request){ [weak self] apiResponse, error in
            if let data = apiResponse?.data{
                let performerProfile = try? self?.jsonDecoder.decode(PerformerProfile.self, from: data)
                completion(performerProfile,apiResponse,error)
                return
            }
            completion(nil,apiResponse,error)
        }
        task.resume()
    }
    
    func deleteWork(workId: String, completion: @escaping (EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/work/\(workId)",relativeTo: hostUrl) else{
            completion(nil,nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue(token ?? "", forHTTPHeaderField: "id_token_customer")
        let task = baseDataRequest(request: request, completion: completion)
        task.resume()
    }
    
    func uploadWorkPhoto(workId: String, photoJpeg: Data, completion: @escaping (EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/work/\(workId)/photo",relativeTo: hostUrl) else{
            completion(nil,nil)
            return
        }
        
        // проверка размера изображения
        // проверка формата изображения
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = photoJpeg
        request.addValue(token ?? "", forHTTPHeaderField: "id_token_customer")
        
        let task = baseDataRequest(request: request,completion: completion)
        task.resume()
    }

    
    func deleteCompletedWorkCustomer(workId: String, completion: @escaping (EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/customer/\(token ?? "")/work/\(workId)",relativeTo: hostUrl) else{
            completion(nil,nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = baseDataRequest(request: request, completion: completion)
        task.resume()
    }
    
    func getPerformersForWork(workId: String, completion: @escaping (_ performers: [PerformerForWork],EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/customer/\(token ?? "")/work/\(workId)",relativeTo: hostUrl) else{
            completion([],nil,nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = baseDataRequest(request: request){ [weak self] apiResponse,error in
            if let data = apiResponse?.data{
                let performers = try? self?.jsonDecoder.decode([PerformerForWork].self, from: data)
                completion(performers ?? [], apiResponse, error)
                return
            }
            completion([],apiResponse,error)
        }
        task.resume()
    }
    
    func getWorks(active: Bool, completion: @escaping (_ works: [Work],EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/customer/\(token ?? "")/work",relativeTo: hostUrl) else{
            completion([],nil,nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(active.description, forHTTPHeaderField: "active")
        
        let task = baseDataRequest(request: request){ [weak self] apiResponse,error in
            if let data = apiResponse?.data{
                let works = try? self?.jsonDecoder.decode([Work].self, from: data)
                completion(works ?? [], apiResponse, error)
                return
            }
            completion([],apiResponse,error)
        }
        task.resume()
    }
    
    func getMyActiveWorks(active: Bool, completion: @escaping (_ activeWorks: [WorkActive],EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/customer/\(token ?? "")/work",relativeTo: hostUrl) else{
            completion([],nil,nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(active.description, forHTTPHeaderField: "active")
        
        let task = baseDataRequest(request: request){ [weak self] apiResponse,error in
            if let data = apiResponse?.data{
                let activeWorks = try? self?.jsonDecoder.decode([WorkActive].self, from: data)
                completion(activeWorks ?? [], apiResponse, error)
                return
            }
            completion([],apiResponse,error)
        }
        task.resume()
    }
    
    func addNewWork(work: Work, completion: @escaping (_ workId: String?,EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/customer/\(token ?? "")/work",relativeTo: hostUrl) else{
            completion(nil,nil,nil)
            return
        }
        let bodyData = try? jsonEncoder.encode(work)
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = bodyData
        
        let task = baseDataRequest(request: request){ apiResponse,error in
            if let data = apiResponse?.data{
                if let dataJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any]{
                    let workId = dataJson["id"] as? String
                    completion(workId,apiResponse,error)
                    return
                }
            }
            completion(nil,apiResponse,error)
        }
        task.resume()
    }
    
    func updatePerformerProfile(profile: PerformerProfile, completion: @escaping (EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/performer/\(token ?? "")",relativeTo: hostUrl) else{
            completion(nil,nil)
            return
        }
        let bodyData = try? jsonEncoder.encode(profile)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        
        let task = baseDataRequest(request: request,completion: completion)
        task.resume()
    }
    
    func getPerformerProfileByIdPublic(performerId: String, completion: @escaping (PerformerInfo?,EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/customer/\(token ?? "")/performer/\(performerId)",relativeTo: hostUrl) else{
            completion(nil,nil,nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = baseDataRequest(request: request) {[weak self] apiResponse,error in
            if let data = apiResponse?.data{
                let performer = try? self?.jsonDecoder.decode(PerformerInfo.self, from: data)
                completion(performer,apiResponse,error)
                return
            }
            completion(nil,apiResponse,error)
        }
        task.resume()
    }
    
    func uploadCustomerPhoto(photoJpeg: Data, completion: @escaping (EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/customer/\(token ?? "")/photo",relativeTo: hostUrl) else{
            completion(nil,nil)
            return
        }
        
        // проверка размера изображения
        // проверка формата изображения
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = photoJpeg
        
        let task = baseDataRequest(request: request,completion: completion)
        task.resume()
    }
    
    func updateCustomerProfile(profile: CustomerProfile, completion: @escaping (EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/customer/\(token ?? "")",relativeTo: hostUrl) else{
            completion(nil,nil)
            return
        }
        let bodyData = try? jsonEncoder.encode(profile)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        
        let task = baseDataRequest(request: request,completion: completion)
        task.resume()
    }
    
    func getCustomerProfile(completion: @escaping (CustomerProfile?,EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/customer/\(token ?? "")",relativeTo: hostUrl) else{
            completion(nil,nil,nil)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = baseDataRequest(request: request){ [weak self] apiResponse,error in
            if let data = apiResponse?.data{
                let customerProfile = try? self?.jsonDecoder.decode(CustomerProfile.self, from: data)
                completion(customerProfile,apiResponse,error)
                return
            }
            completion(nil,apiResponse,error)
        }
        task.resume()
    }
    
    func getPerformersListByCategory(category: String, completion: @escaping ([Performer],EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/customer/\(token ?? "")/performers",relativeTo: hostUrl) else{
            completion([],nil,nil)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(category, forHTTPHeaderField: "category")
        
        let task = baseDataRequest(request: request){ [weak self] apiResponse,error in
            if let data = apiResponse?.data{
                let performersList = try? self?.jsonDecoder.decode([Performer].self, from: data)
                completion(performersList ?? [],apiResponse,error)
                return
            }
            completion([],apiResponse,error)
        }
        task.resume()
    }
    
    func restorePassword(email: String, completion: @escaping (EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/account/password",relativeTo: hostUrl) else{
            completion(nil,nil)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(email, forHTTPHeaderField: "email")
        
        let task = baseDataRequest(request: request,completion: completion)
        task.resume()
    }
    
    func getAccountInfo(completion: @escaping (AccountInfoModel?,EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/account/\(token ?? "")",relativeTo: hostUrl) else{
            completion(nil,nil,nil)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = baseDataRequest(request: request) {[weak self] apiResponse, error in
            if let data = apiResponse?.data{
                let accountInfo = try? self?.jsonDecoder.decode(AccountInfo.self, from: data)
                completion(accountInfo,apiResponse,error)
                return
            }
            completion(nil,apiResponse,error)
        }
        task.resume()
    }
    
    func registerAndGetToken(email: String, password: String, lang: String, completion: @escaping (EmassiApiResponse?,Error?) -> Void){
        
        guard let url = URL(string: "/api/v1/account", relativeTo: hostUrl) else {
            completion(nil, nil)
            return
        }
        
        let bodyString = """
            {
                "email": "\(email)",
                "password": "\(password)",
                "lang": "\(lang)"
            }
        """
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 30)
        request.httpMethod = "POST"
        request.httpBody = bodyString.data(using: .utf8)
        
        let sign = computeSign(email: email, password: password)
        
        request.addValue(sign, forHTTPHeaderField: "sign")
        
        let task = baseDataRequest(request: request, completion: completion)
        task.resume()
    }
    
    func getAccountToken(email: String, password: String, completion: @escaping (EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/account", relativeTo: hostUrl)?.appending(queryItems: [
            .init(name: "email", value: email),
            .init(name: "password", value: password)
        ]) else {return}
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 30)
        request.httpMethod = "GET"
        
        let sign = computeSign(email: email, password: password)
        request.addValue(sign, forHTTPHeaderField: "sign")
        request.addValue(email, forHTTPHeaderField: "email")
        request.addValue(password, forHTTPHeaderField: "password")
        
        let task = baseDataRequest(request: request, completion: completion)
        task.resume()
    }
    
    func baseDataRequest(request: URLRequest, completion: @escaping (EmassiApiResponse?, Error?)-> Void) -> URLSessionDataTask{
        
        let completionHandler: (Data?, URLResponse?, Error?) -> Void = { [weak self] data,response, error in
            if let data = data{
                print("\n____RESPONSE____\n \(String(data: data, encoding: .utf8) ?? "")\n____END____\n")
                
                if var apiResponse = try? self?.jsonDecoder.decode(EmassiApiResponse.self, from: data){
                    if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]{
                        if let dataJson = json["data"]{
                            let dataObj = try? JSONSerialization.data(withJSONObject: dataJson)
                            apiResponse = apiResponse.appendingData(data: dataObj)
                        }
                    }
                    if let responseData = apiResponse.data{
                        if let dataWithToken = try? JSONSerialization.jsonObject(with: responseData) as? [String: String]{
                            self?.token = dataWithToken["token"]
                        }
                    }
                    completion(apiResponse,error)
                    return
                }
            }
            completion(nil,error)
        }
        let dataTask = dataFetchURLSession.dataTask(with: request, completionHandler: completionHandler)
        return dataTask
    }
    
    func computeSign(email: String, password: String) -> String{
        let codingString = email.trimmingCharacters(in: .whitespacesAndNewlines)+password.trimmingCharacters(in: .whitespacesAndNewlines)
        let sha256 = codingString.sha256()
        guard let sha256Data = sha256.data(using: .utf8) else {return ""}
        guard let sKeyData = skey.data(using: .utf8) else {return ""}
        let hmac = HMAC<SHA256>.authenticationCode(for: sha256Data, using: .init(data: sKeyData))
        let hmacString = hmac.description
        var firstIndexOfDoubleDot: String.Index? = hmacString.firstIndex(of: ":")
        if let dotsIndex = firstIndexOfDoubleDot{
            firstIndexOfDoubleDot = hmacString.index(dotsIndex, offsetBy: 1)
        }
        let resultedString = hmacString[(firstIndexOfDoubleDot ?? hmacString.startIndex)...]
        return resultedString.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

struct EmassiRequestInfo {
    let address: String
    let method: URLRequest.HTTPMethod
    var attachHttpHeaders: [String:String]?
    var queryParams: [URLQueryItem]?
    var httpBody: Data?
}
