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
        
        let task = imageDownloadURLSession.dataTask(with: request) {[weak self] data, response, error in
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
        PerformersCategory(name: "Перевозки и курьерские услуги", value: "0100", imageAddress: "categoryDelivery",subCategories: [
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
            .init(name: "Перевозки и курьерские услуги - Другое", value: "0118")
        ]),
        
        PerformersCategory(name: "Строительство и ремонтные работы", value: "0200", imageAddress: "categoryBuilders",subCategories: [
            .init(name: "Услуги дизайнера", value: "0201"),
            .init(name: "Ремонт под ключ", value: "0202"),
            .init(name: "Проектирование и услуги архитектора", value: "0203"),
            .init(name: "Услуги сантехника", value: "0204"),
            .init(name: "Электромонтажные работы", value: "0205"),
            .init(name: "Отделка помещений", value: "0206"),
            .init(name: "Потолочные работы", value: "0207"),
            .init(name: "Напольные работы", value: "0208"),
            .init(name: "Изготовление и монтаж лестниц", value: "0209"),
            .init(name: "Укладка плитки", value: "0210"),
            .init(name: "Установка и ремонт дверей и замков", value: "0211"),
            .init(name: "Установка и ремонт окон", value: "0212"),
            .init(name: "Кровельные работы", value: "0213"),
            .init(name: "Фасадные работы", value: "0214"),
            .init(name: "Ландшафтные работы и дизайн", value: "0215"),
            .init(name: "Сварочные работы", value: "0216"),
            .init(name: "Установка отопления и систем вентиляции", value: "0217"),
            .init(name: "Установка кондиционеров", value: "0218"),
            .init(name: "Установка бытовой техники", value: "0219"),
            .init(name: "Строительно-монтажные работы", value: "0220"),
            .init(name: "Охранные системы и видеонаблюдение", value: "0221"),
            .init(name: "Умный дом", value: "0222"),
            .init(name: "Изоляционные работы", value: "0223"),
            .init(name: "Малярные работы", value: "0224"),
            .init(name: "Изготовление, сборка и ремонт мебели", value: "0225"),
            .init(name: "Уборка и вывоз строительного мусора", value: "0226"),
            .init(name: "Мастер на час", value: "0227"),
            .init(name: "Строительство и ремонтные работы - Другое", value: "0228"),
        ]),
        PerformersCategory(name: "Быт и клининговые услуги", value: "0300", imageAddress: "categoryCleaning",subCategories: [
            .init(name: "Ремонт бытовой техники", value: "0301"),
            .init(name: "Ремонт цифровой техники", value: "0302"),
            .init(name: "Ремонт садовой техники", value: "0303"),
            .init(name: "Уборка помещений", value: "0304"),
            .init(name: "Генеральная уборка", value: "0305"),
            .init(name: "Уборка прилегающей территории", value: "0306"),
            .init(name: "Вынос мусора", value: "0307"),
            .init(name: "Услуги химчистки", value: "0308"),
            .init(name: "Мойка окон", value: "0309"),
            .init(name: "Мойка фасадов", value: "0310"),
            .init(name: "Дезинфекция помещений", value: "0311"),
            .init(name: "Дезинсекция", value: "0312"),
            .init(name: "Стирка и глажка белья", value: "0313"),
            .init(name: "Услуги сиделки", value: "0314"),
            .init(name: "Услуги няни", value: "0315"),
            .init(name: "Работы в саду, огороде", value: "0316"),
            .init(name: "Ремонт обуви", value: "0317"),
            .init(name: "Ремонт часов", value: "0318"),
            .init(name: "Ремонт ювелирных изделий", value: "0319"),
            .init(name: "Услуги ателье", value: "0320"),
            .init(name: "Уход за животными", value: "0321"),
            .init(name: "Помощь ветеринара", value: "0322"),
            .init(name: "Быт и клининговые услуги - Другое", value: "0323"),
        ]),
        PerformersCategory(name: "Перевод и копирайтинг", value: "0400", imageAddress: "categoryTranslate",subCategories: [
            .init(name: "Копирайтинг", value: "0401"),
            .init(name: "Рерайтинг", value: "0402"),
            .init(name: "Сбор и обработка информации", value: "0403"),
            .init(name: "Набор текста", value: "0404"),
            .init(name: "Разработка презентаций", value: "0405"),
            .init(name: "Перевод текста", value: "0406"),
            .init(name: "Перевод документов и нотариальное заверение", value: "0407"),
            .init(name: "Перевод аудио и видеозаписей", value: "0408"),
            .init(name: "Услуги синхронного переводчика", value: "0409"),
            .init(name: "Апостиль и легализация", value: "0410"),
            .init(name: "Перевод и копирайтинг - Другое", value: "0411"),
        ]),
        PerformersCategory(name: "Web - разработка и IT услуги",value: "0500", imageAddress: "categoryIT", subCategories: [
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
            .init(name: "Web - разработка и IT услуги - Другое", value: "0512"),
        ]),
        PerformersCategory(name: "Дизайн",value: "0600", imageAddress: "categoryDesign",subCategories: [
            .init(name: "Дизайн интерьера", value: "0601"),
            .init(name: "Архитектурный дизайн", value: "0602"),
            .init(name: "Ландшафтный дизайн", value: "0603"),
            .init(name: "Дизайн сайта, приложений, иконок", value: "0604"),
            .init(name: "Дизайн логотипов, визиток", value: "0605"),
            .init(name: "Создание фирменного стиля", value: "0606"),
            .init(name: "Полиграфический дизайн", value: "0607"),
            .init(name: "Создание иллюстраций, рисунков", value: "0608"),
            .init(name: "3D дизайн и анимация", value: "0609"),
            .init(name: "Инфографика, дизайн презентаций", value: "0610"),
            .init(name: "Дизайн наружной рекламы, стендов, баннеров", value: "0611"),
            .init(name: "Дизайн - Другое", value: "0612"),
        ]),
        PerformersCategory(name: "Красота и здоровье, спорт",value: "0700", imageAddress: "categorySport",subCategories: [
            .init(name: "Массаж", value: "0701"),
            .init(name: "Парикмахерские услуги", value: "0702"),
            .init(name: "Макияж", value: "0703"),
            .init(name: "Косметология", value: "0704"),
            .init(name: "Уход за ногтями", value: "0705"),
            .init(name: "Услуги стилиста", value: "0706"),
            .init(name: "Уход за бровями и ресницами", value: "0707"),
            .init(name: "Депиляция", value: "0708"),
            .init(name: "Консультация диетолога", value: "0709"),
            .init(name: "Помощь персонального тренера", value: "0710"),
            .init(name: "Красота, здоровье, спорт - Другое", value: "0711"),
        ]),
        PerformersCategory(name: "Фото и видео",value: "0800", imageAddress: "categoryPhoto",subCategories: [
            .init(name: "Фотосъемка", value: "0801"),
            .init(name: "Видеосъемка", value: "0802"),
            .init(name: "Монтаж видео и аудио записей", value: "0803"),
            .init(name: "Обработка фотографий", value: "0804"),
            .init(name: "Оцифровка видео и фото", value: "0805"),
            .init(name: "Создание видеороликов", value: "0806"),
            .init(name: "Съемка при помощи дронов", value: "0807"),
            .init(name: "Фото и видео - Другое", value: "0808"),
        ]),
        PerformersCategory(name: "Репетиторы и обучение",value: "0900", imageAddress: "categoryEducation", subCategories: [
            .init(name: "Языковые репетиторы", value: "0901"),
            .init(name: "Подготовка к школе", value: "0902"),
            .init(name: "Подготовка к вступительным экзаменам в ВУЗ", value: "0903"),
            .init(name: "Преподавание на дому", value: "0904"),
            .init(name: "Услуги логопеда", value: "0905"),
            .init(name: "Обучение музыке", value: "0906"),
            .init(name: "Обучение танцам", value: "0907"),
            .init(name: "Спортивные тренеры", value: "0908"),
            .init(name: "Обучение вождению авто", value: "0909"),
            .init(name: "Обучение вождению мотоциклов", value: "0910"),
            .init(name: "Репетиторы и обучение - Другое", value: "0911"),
        ]),
        PerformersCategory(name: "Обслуживание и ремонт транспорта",value: "1000", imageAddress: "categoryRepairCar", subCategories: [
            .init(name: "Ремонт велосипедов", value: "1001"),
            .init(name: "Ремонт авто", value: "1002"),
            .init(name: "Ремонт мотоциклов", value: "1003"),
            .init(name: "Ремонт строительной техники", value: "1004"),
            .init(name: "Услуги шиномонтажника", value: "1005"),
            .init(name: "Мойка", value: "1006"),
            .init(name: "Химчистка салона", value: "1007"),
            .init(name: "Тюнинг авто и мотоциклов", value: "1008"),
            .init(name: "Кузовные работы", value: "1009"),
            .init(name: "Помощь на дороге", value: "1010"),
            .init(name: "Доставка топлива", value: "1011"),
            .init(name: "Техобслуживание и диагностика", value: "1012"),
            .init(name: "Эвакуация транспорта", value: "1013"),
            .init(name: "Обслуживание и ремонт транспорта - Другое", value: "1014"),
        ]),
        PerformersCategory(name: "Организация мероприятий и праздников",value: "1100", imageAddress: "categoryHoliday", subCategories: [
            .init(name: "Организация частных мероприятий и праздников", value: "1101"),
            .init(name: "Организация корпоративных мероприятий и праздников", value: "1102"),
            .init(name: "Организация свадебных мероприятий", value: "1103"),
            .init(name: "Услуги поваров", value: "1104"),
            .init(name: "Услуги бармена и баристы", value: "1105"),
            .init(name: "Услуги официантов", value: "1106"),
            .init(name: "Услуги музыкантов и музыкальное сопровождение", value: "1107"),
            .init(name: "Услуги ведущих мероприятия и аниматоров", value: "1108"),
            .init(name: "Организация мастер классов", value: "1109"),
            .init(name: "Организация банкетов, фуршетов, кейтеринг", value: "1110"),
            .init(name: "Дизайн и оформление мероприятий и праздников", value: "1111"),
            .init(name: "Организация мероприятий и праздников - Другое", value: "1112"),
        ]),
        PerformersCategory(name: "Профессиональная помощь",value: "1200", imageAddress: "categoryProfessionalHelp", subCategories: [
            .init(name: "Помощь юриста", value: "1201"),
            .init(name: "Помощь бухгалтера", value: "1202"),
            .init(name: "Консалтинговые услуги", value: "1203"),
            .init(name: "Личная охрана, охрана объектов, грузов", value: "1204"),
            .init(name: "Услуги риелтора", value: "1205"),
            .init(name: "Профессиональная помощь - Другое", value: "1206"),
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
