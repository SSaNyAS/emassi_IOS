//
//  EmassiApiDelegate.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 08.09.2022.
//

import Foundation
import Network
import CryptoKit
import KeychainAccess

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
    static let privacyPolicy = "https://docs.google.com/file/d/1lnTiDrJyXIwrXd21AwsqCElzB-tr5W9l/edit?usp=docslist_api&filetype=msword"
    static let faq = "https://docs.google.com/file/d/1HFjYpoImGN0m63rHOd4jg1zclsIi4R_n/edit?usp=docslist_api&filetype=msword"
    
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
        encoder.outputFormatting = [.withoutEscapingSlashes]
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
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.httpBody = bodyString.data(using: .utf8)
        
        let task = baseDataRequest(request: request, completion: completion)
        task.resume()
    }
    
    func getAllPerformersSubCategories(completion: @escaping ([PerformersSubCategory], EmassiApiResponse?, Error?) -> Void){
        let allSubCategoriesArray = categories.map({$0.subCategories})
        var temp: [String:PerformersSubCategory] = [:]
        
        for subCategories in allSubCategoriesArray{
            subCategories.forEach({
                temp.updateValue($0, forKey: $0.value)
            })
        }
        let allSubCategories = temp.values.sorted(by: {
            $0.value < $1.value
        })
        completion(allSubCategories,nil,nil)
    }
    
    func getPerformersCategories(completion: @escaping ([PerformersCategory], EmassiApiResponse?, Error?) -> Void){
        completion(categories,nil,nil)
    }
    
    func getCategoryInfo(category: String, completion: @escaping (PerformersSubCategory?, EmassiApiResponse?, Error?) -> Void){
        getPerformersCategories(completion: { categories, apiResponse, error in
                    
            let allSubCategories = categories.map({$0.subCategories})
            
            for subCategories in allSubCategories{
                let subcategory = subCategories.first { subCat in
                    subCat.value == category
                }
                if let subcategory = subcategory{
                    completion(subcategory,nil,nil)
                    return
                }
            }
            for categoryMain in categories{
                if categoryMain.value == category{
                    let categoryAsSubCategory = PerformersSubCategory(name: categoryMain.name, value: categoryMain.value)
                    completion(categoryAsSubCategory,nil,nil)
                    return
                }
            }
            completion(nil,nil,nil)
        })
    }
    
    func getSuperCategory(subCategoryId: String, completion: @escaping (PerformersCategory?, EmassiApiResponse?, Error?) -> Void){
        getPerformersCategories(completion: { categories, apiResponse, error in
            let superCategory = categories.first { performersCategory in
                performersCategory.subCategories.contains { subCategory in
                    subCategory.value == subCategoryId
                }
            }
            completion(superCategory,nil,nil)
        })
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
        request.addValue("application/json", forHTTPHeaderField: "content-type")
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
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.httpBody = bodyString.data(using: .utf8)
        
        let task = baseDataRequest(request: request, completion: completion)
        task.resume()
    }
    
    func sendPerformerFeedback(workId: String, rating: Float, text: String, completion: @escaping (EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/performer/\(token ?? "")/work/\(workId)/feedback",relativeTo: hostUrl) else{
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
        request.addValue("application/json", forHTTPHeaderField: "content-type")
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
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.httpBody = bodyString.data(using: .utf8)
        
        let task = baseDataRequest(request: request,completion: completion)
        task.resume()
    }
    
    func changeWorkStatus(workId: String, action: WorkStatus, completion: @escaping (EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/performer/\(token ?? "")/work/\(workId)",relativeTo: hostUrl) else{
            completion(nil,nil)
            return
        }
        let bodyString = """
        {
            "action": "\(action.rawValue)"
        }
        """
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.httpBody = bodyString.data(using: .utf8)
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        
        let task = baseDataRequest(request: request,completion: completion)
        task.resume()
    }
    
    func getWorkForPerformer(workId: String,  completion: @escaping (WorkRequest?,EmassiApiResponse?,Error?) -> Void){
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
    
    func getWorkInfoForMe(workId: String,  completion: @escaping (_ workWithCustomer: WorkWithCustomer?,EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/performer/\(token ?? "")/work/\(workId)",relativeTo: hostUrl) else{
            completion(nil,nil,nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = baseDataRequest(request: request){ [weak self] apiResponse, error in
            if let data = apiResponse?.data{
                var workWithCustomer: WorkWithCustomer?
                
                guard let dataJson = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                    completion(workWithCustomer,apiResponse,error)
                    return
                }
                
                if let workWithCustomer = try? self?.jsonDecoder.decode(WorkWithCustomer.self, from: data){
                    completion(workWithCustomer,apiResponse,error)
                    return
                }
                
                if let workJsonObject = dataJson["work"]{
                    if let workData = try? JSONSerialization.data(withJSONObject: workJsonObject){
                        if let work = try? self?.jsonDecoder.decode(WorkRequest.self, from: workData){
                            if workWithCustomer == nil{
                                workWithCustomer = .init()
                            }
                            workWithCustomer?.work = work
                        }
                    }
                }
                if let customerJsonObject = dataJson["customer"]{
                    if let customerData = try? JSONSerialization.data(withJSONObject: customerJsonObject){
                        
                        if let customer = try? self?.jsonDecoder.decode(Customer.self, from: customerData){
                            if workWithCustomer == nil{
                                workWithCustomer = .init()
                            }
                            workWithCustomer?.customer = customer
                        }
                    }
                }
                completion(workWithCustomer,apiResponse,error)
                return
            }
            completion(nil,apiResponse,error)
        }
        task.resume()
    }
    
    func getAllWorks(active: Bool, type: String, startDate: Date? = nil, completion: @escaping ([AllWork],EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/performer/\(token ?? "")/work",relativeTo: hostUrl) else{
            completion([],nil,nil)
            return
        }
        let startDateIntervalEncoded = try? jsonEncoder.encode(startDate)
        let startDateInterval = startDateIntervalEncoded == nil ? "0" : String(data: startDateIntervalEncoded!, encoding: .utf8) ?? "0"
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("\(active)", forHTTPHeaderField: "active")
        request.addValue(type, forHTTPHeaderField: "type")
        request.addValue("\(startDateInterval)", forHTTPHeaderField: "dt_start")
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        
        let task = baseDataRequest(request: request){ [weak self] apiResponse, error in
            if let data = apiResponse?.data{
                let allWorks = try? self?.jsonDecoder.decode([AllWork].self, from: data)
                completion(allWorks ?? [],apiResponse,error)
                return
            }
            completion([],apiResponse,error)
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
        
        let boundary = "Boundary-\(UUID().uuidString)"
        let date = Date().timeIntervalSince1970.rounded(.down)
        let photoBody = createMultipartFormFor(parameterName: "photo", contentType: "image/jpg",fileName: "work\(workId)_date\(date)_", data: photoJpeg, boundary: boundary)
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = photoBody
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
    
    func getMyWorksRequests(active: Bool, completion: @escaping (_ works: [Work],EmassiApiResponse?,Error?) -> Void){
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
    
    func addNewWork(work: WorkCreate, completion: @escaping (_ workId: String?,EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/customer/\(token ?? "")/work",relativeTo: hostUrl) else{
            completion(nil,nil,nil)
            return
        }
        DispatchQueue.global(qos: .utility).async { [weak self] in
            let bodyData = try? self?.jsonEncoder.encode(work)
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            request.httpBody = bodyData
            
            let task = self?.baseDataRequest(request: request){ apiResponse,error in
                if let data = apiResponse?.data{
                    if let dataJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any]{
                        let workId = dataJson["id"] as? String
                        completion(workId,apiResponse,error)
                        return
                    }
                }
                completion(nil,apiResponse,error)
            }
            if task == nil {
                completion(nil,nil,nil)
            }
            task?.resume()
        }
        
    }
    
    func downloadWorkPhoto(workId: String, photoId: String, completion: @escaping (Data?, EmassiApiResponse?) -> Void){
        guard let url = URL(string: "/api/v1/work/\(workId)/photo/\(photoId)",relativeTo: hostUrl) else{
            completion(nil,nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = imageDownloadURLSession.dataTask(with: request) { [weak self] data, _, error in
            let apiResponse = self?.getApiResponse(data: data ?? Data())
            guard error == nil else {
                completion(nil,apiResponse)
                return
            }
            
            completion(data,apiResponse)
        }
        task.resume()
    }
    
    func downloadCustomerPhotoPublic(customerId: String, completion: @escaping (Data?, EmassiApiResponse?) -> Void){
        guard let url = URL(string: "/api/v1/performer/\(token ?? "")/customer/\(customerId)/photo",relativeTo: hostUrl) else{
            completion(nil,nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = imageDownloadURLSession.dataTask(with: request) { [weak self] data, _, error in
            let apiResponse = self?.getApiResponse(data: data ?? Data())
            guard error == nil else {
                completion(nil,apiResponse)
                return
            }
            
            completion(data,apiResponse)
        }
        task.resume()
    }
    
    func downloadPerformerPhotoPublic(performerId: String, completion: @escaping (Data?, EmassiApiResponse?) -> Void){
        guard let url = URL(string: "/api/v1/customer/\(token ?? "")/performer/\(performerId)/photo",relativeTo: hostUrl) else{
            completion(nil,nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = imageDownloadURLSession.dataTask(with: request) {[weak self] data, _, error in
            let apiResponse = self?.getApiResponse(data: data ?? Data())
            guard error == nil else {
                completion(nil,apiResponse)
                return
            }
            
            completion(data,apiResponse)
        }
        task.resume()
    }
    
    func downloadPerformerPhotoPublic(completion: @escaping (Data?, EmassiApiResponse?) -> Void){
        guard let url = URL(string: "/api/v1/performer/\(token ?? "")/photo",relativeTo: hostUrl) else{
            completion(nil,nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = imageDownloadURLSession.dataTask(with: request) { [weak self] data, _, error in
            let apiResponse = self?.getApiResponse(data: data ?? Data())
            guard error == nil else {
                completion(nil,apiResponse)
                return
            }
            
            completion(data,apiResponse)
        }
        task.resume()
    }
    
    func downloadCustomerPhotoPublic(completion: @escaping (Data?, EmassiApiResponse?) -> Void){
        guard let url = URL(string: "/api/v1/customer/\(token ?? "")/photo",relativeTo: hostUrl) else{
            completion(nil,nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = imageDownloadURLSession.dataTask(with: request) { [weak self] data, _, error in
            let apiResponse = self?.getApiResponse(data: data ?? Data())
            guard error == nil else {
                completion(nil,apiResponse)
                return
            }
            
            completion(data,apiResponse)
        }
        task.resume()
    }
    
    func updatePerformerProfile(profile: RequestPerformerProfile, completion: @escaping (EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/performer/\(token ?? "")",relativeTo: hostUrl) else{
            completion(nil,nil)
            return
        }
        
        let bodyData = try? self.jsonEncoder.encode(profile)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
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
    
    func uploadPerformerDocs(photoJpeg: Data, documentType: DocumentType, documentName: String, completion: @escaping (EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/performer/\(token ?? "")/docs",relativeTo: hostUrl) else{
            completion(nil,nil)
            return
        }
        
        // проверка размера изображения
        // проверка формата изображения
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "content-type")
        
        let date = Date().timeIntervalSince1970.rounded(.down)
        
        var form = createMultipartFormFor(parameterName: "file", contentType: "image/jpeg", fileName: "\(token ?? "f")_\(documentName)_date\(date)_.jpeg", data: photoJpeg, boundary: boundary)
        
        if let documentTypeData = documentType.rawValue.data(using: .utf8){
            form += createMultipartFormFor(parameterName: "type", contentType: "text", data: documentTypeData, boundary: boundary)
        }
        if let nameData = documentName.data(using: .utf8){
            form += createMultipartFormFor(parameterName: "name", contentType: "text", data: nameData, boundary: boundary)
        }
    
        request.httpBody = form
        
        let task = baseDataRequest(request: request,completion: completion)
        task.resume()
    }
    
    func deletePerformerDocs(docId: String, completion: @escaping (EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/performer/\(token ?? "")/docs/\(docId)",relativeTo: hostUrl) else{
            completion(nil,nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = baseDataRequest(request: request, completion: completion)
        task.resume()
    }
    
    func getPerformerDocs(docId: String, completion: @escaping (Data?,EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/performer/\(token ?? "")/docs/\(docId)",relativeTo: hostUrl) else{
            completion(nil,nil,nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let task = imageDownloadURLSession.dataTask(with: request) {[weak self] data, response, error in
            let apiResponse = self?.getApiResponse(data: data ?? Data())
            
            guard error == nil else {
                completion(data,apiResponse,error)
                return
            }
        
            completion(data,apiResponse,error)
        }
        task.resume()
    }
    
    func uploadPerformerPhoto(photoJpeg: Data, completion: @escaping (EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/performer/\(token ?? "")/photo",relativeTo: hostUrl) else{
            completion(nil,nil)
            return
        }
        
        // проверка размера изображения
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let date = Date().timeIntervalSince1970.rounded(.down)
        let photoForm = createMultipartFormFor(parameterName: "photo", contentType: "image/jpg", fileName: "performer_\(token ?? "filename")_date\(date)_.jpg", data: photoJpeg, boundary: boundary)
        
        request.httpBody = photoForm
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "content-type")
        imageDownloadURLSession.configuration.urlCache?.removeCachedResponse(for: .init(url: url))
        
        let task = baseDataRequest(request: request,completion: completion)
        task.resume()
    }
    
    func uploadCustomerPhoto(photoJpeg: Data, completion: @escaping (EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/customer/\(token ?? "")/photo",relativeTo: hostUrl) else{
            completion(nil,nil)
            return
        }
        
        // проверка размера изображения
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let date = Date().timeIntervalSince1970.rounded(.down)
        let photoForm = createMultipartFormFor(parameterName: "photo", contentType: "image/jpg", fileName: "customer_\(token ?? "filename")_date\(date)_.jpg", data: photoJpeg, boundary: boundary)
        
        request.httpBody = photoForm
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "content-type")
        imageDownloadURLSession.configuration.urlCache?.removeCachedResponse(for: .init(url: url))

        let task = baseDataRequest(request: request,completion: completion)
        task.resume()
    }
    
    func updateCustomerProfile(profile: RequestCustomerProfile, completion: @escaping (EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/customer/\(token ?? "")",relativeTo: hostUrl) else{
            completion(nil,nil)
            return
        }
        let bodyData = try? jsonEncoder.encode(profile)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
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
    
    func getPerformersListByCategory(category: String, completion: @escaping ([PerformerForList],EmassiApiResponse?,Error?) -> Void){
        guard let url = URL(string: "/api/v1/customer/\(token ?? "")/performers",relativeTo: hostUrl) else{
            completion([],nil,nil)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(category, forHTTPHeaderField: "category")
        
        let task = baseDataRequest(request: request){ [weak self] apiResponse,error in
            if let data = apiResponse?.data{
                let performersList = try? self?.jsonDecoder.decode([PerformerForList].self, from: data)
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
        request.addValue(email, forHTTPHeaderField: "email")
        request.addValue(password, forHTTPHeaderField: "password")
        request.addValue(lang, forHTTPHeaderField: "lang")
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        
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
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        let task = baseDataRequest(request: request, completion: completion)
        task.resume()
    }
    
    func baseDataRequest(request: URLRequest, completion: @escaping (EmassiApiResponse?, Error?)-> Void) -> URLSessionDataTask{
        
        let completionHandler: (Data?, URLResponse?, Error?) -> Void = { [weak self] data,response, error in
            if let data = data{
                print("\n____RESPONSE____\n \(String(data: data, encoding: .utf8) ?? "")\n____END____\n")
                
                if let apiResponse = self?.getApiResponse(data: data){
                    if let responseData = apiResponse.data{
                        if let dataWithToken = try? JSONSerialization.jsonObject(with: responseData) as? [String: String]{
                            if let token = dataWithToken["token"], token.isEmpty == false{
                                self?.token = token
                            }
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
    
    func getApiResponse(data: Data) -> EmassiApiResponse?{
        var apiResponse: EmassiApiResponse?
        
        apiResponse = try? jsonDecoder.decode(EmassiApiResponse.self, from: data)
        if apiResponse == nil {
            if let errorObj = try? JSONSerialization.jsonObject(with: data) as? [String: Any]{
                if let jsonError = errorObj["error"]{
                    if let jsonErrorData = try? JSONSerialization.data(withJSONObject: jsonError){
                        apiResponse = try? jsonDecoder.decode(EmassiApiResponse.self, from: jsonErrorData)
                    }
                }
            }
        }
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]{
            if let dataJson = json["data"]{
                let dataObj = try? JSONSerialization.data(withJSONObject: dataJson)
                apiResponse = apiResponse?.appendingData(data: dataObj)
            }
        }
        return apiResponse
    }
    
    func createMultipartFormFor(parameterName: String, contentType: String,fileName: String? = nil, data: Data, boundary: String) -> Data{
        var bodyData: Data = Data()
        if let boundaryHead = "--\(boundary)\r\n".data(using: .utf8){
            bodyData.append(boundaryHead)
        }
        if let contentDisposition = "Content-Disposition:form-data; name=\"\(parameterName)\"".data(using: .utf8){
            bodyData.append(contentDisposition)
        }
        if fileName != nil {
            if let filenameData = "; filename=\"\(fileName!)\"\r\n".data(using: .utf8){
                bodyData.append(filenameData)
            }
            if let contentTypeData = "Content-Type: \(contentType)".data(using: .utf8){
                bodyData.append(contentTypeData)
            }
        }
        if let newLinesData = "\r\n\r\n".data(using: .utf8){
            bodyData.append(newLinesData)
        }
        
        if contentType.hasPrefix("text"){
            bodyData.append(data)
        } else if contentType.hasPrefix("file"){
            let src = String(data: data, encoding: .utf8)
            if let url = URL(string: src ?? ""){
                if let fileData = try? Data(contentsOf: url){
                    bodyData.append(fileData)
                }
            }
        } else if contentType.hasPrefix("image"){
            bodyData += data
        }
        if let boundaryFooter = "\r\n--\(boundary)--\r\n".data(using: .utf8){
            bodyData.append(boundaryFooter)
        }
        return bodyData
    }
    
    func saveToKeyChain(username: String, password: String, completion: @escaping (Error?) -> Void){
        DispatchQueue.global().async { [weak self] in
            guard let hostString = self?.hostUrl?.absoluteString else {
                return
            }
            let keyChain = Keychain(server: hostString, protocolType: .https)
                .synchronizable(true)
                .authenticationPrompt("used to save password in keychain")
                .accessibility(.afterFirstUnlock, authenticationPolicy: [.biometryAny,.devicePasscode])
            do{
                keyChain.setSharedPassword(password, account: username)
                try keyChain.set(username, key: "email")
                try keyChain.set(password, key: "password")
                completion(nil)
            } catch{
                completion(error)
            }
        }
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
    
    let categories = [
        PerformersCategory(name: "Перевозки и курьерские услуги", value: "0100", imageAddress: "",subCategories: [
            .init(name: "Перевозка вещей во время переезда", value: "0101"),
            .init(name: "Грузоперевозки", value: "0102"),
            .init(name: "Пассажирские перевозки", value: "0103"),
            .init(name: "Услуги грузчиков", value: "0104"),
            .init(name: "Манипуляторы и подъемные краны", value: "0105"),
            .init(name: "Услуги пешего курьера", value: "0106"),
            .init(name: "Услуги курьера на авто", value: "0107"),
            .init(name: "Доставка товара из интернет-магазина", value: "0108"),
            .init(name: "Доставка цветов", value: "0109"),
            .init(name: "Доставка продуктов и еды из ресторанов", value: "0110"),
            .init(name: "Доставка лекарств", value: "0111"),
            .init(name: "Курьерская доставка", value: "0112"),
            .init(name: "Аренда склада", value: "0113"),
            .init(name: "Услуги такси", value: "0114"),
            .init(name: "Услуга трезвый водитель", value: "0115"),
            .init(name: "Международные или междугородние перевозки", value: "0116"),
            .init(name: "Эвакуация транспорта", value: "0117"),
            .init(name: "Другое", value: "0118")
        ]),
        
        PerformersCategory(name: "Строительство и ремонтные работы", value: "0200", imageAddress: "",subCategories: [
            
        ]),
        PerformersCategory(name: "Быт и клининговые услуги", value: "0300", imageAddress: "",subCategories: [
            
        ]),
        PerformersCategory(name: "Перевод и копирайтинг", value: "0400", imageAddress: "",subCategories: [
            
        ]),
        
        PerformersCategory(name: "Преподаватели",value: "cat1", imageAddress: "category1", subCategories: [
            .init(name: "Репетитор по математике", value: "cat1"),
            .init(name: "Репетитор по истории", value: "cat2"),
            .init(name: "Репетитор по Географии", value: "cat3"),
        ]),
        
        PerformersCategory(name: "Дизайнеры",value: "cat6", imageAddress: "category2",subCategories: [
            .init(name: "Графический дизайнер", value: "cat4"),
            .init(name: "Дизайнер интерьеров", value: "cat5")
        ]),
        
        PerformersCategory(name: "Разработка и поддержка ПО",value: "0501", imageAddress: "category3", subCategories: [
            .init(name: "Разработка и поддержка ПО", value: "0501"),
            .init(name: "Разработка и поддержка приложений для iOS", value: "0502"),
            .init(name: "Разработка и поддержка приложений для Android", value: "0503"),
            .init(name: "Создание сайта под ключ", value: "0504"),
            .init(name: "Дизайн сайта и приложений", value: "0505"),
            .init(name: "Верстка", value: "0506"),
            .init(name: "Поддержка и доработка сайтов", value: "0507"),
            .init(name: "Тестирование ПО", value: "0508"),
            .init(name: "Администрирование серверов", value: "0509"),
            .init(name: "Разработка и внедрение CRM систем", value: "0510"),
            .init(name: "Внедрение 1С", value: "0511"),
            .init(name: "Другое", value: "0512"),
        ]),
        
        PerformersCategory(name: "Персональные тренера",value: "cat4", imageAddress: "category4", subCategories: [
            .init(name: "Персональный тренер", value: "personalTrainer")
        ]),
    ]
}

struct EmassiRequestInfo {
    let address: String
    let method: URLRequest.HTTPMethod
    var attachHttpHeaders: [String:String]?
    var queryParams: [URLQueryItem]?
    var httpBody: Data?
}

struct MultipartData: Codable{
    let parameterName: String
    let dataType: String
    let data: Data
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.parameterName, forKey: .parameterName)
        try container.encode(self.dataType, forKey: .dataType)
        try container.encode(self.data, forKey: .data)
    }
    
    enum CodingKeys: String, CodingKey {
        case parameterName = "key"
        case dataType = "type"
        case data = "value"
    }
}
