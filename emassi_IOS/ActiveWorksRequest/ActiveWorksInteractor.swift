//
//  ActiveWorksInteractor.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 04.10.2022.
//

import Foundation
protocol ActiveWorksInteractorDelegate: AnyObject{
    func getWorks(active: Bool, completion: @escaping (_ works: [WorkActive], EmassiApiResponse?, Error?) -> Void)
    func getPerformersForWork(workId: String, completion: @escaping ([PerformerForWork]) -> Void)
    func getCategoryName(categoryId: String, completion: @escaping (String?) -> Void)
    func deleteWork(workId: String, completion: @escaping (EmassiApiResponse?, Error?) -> Void)
    func getPerformerPhoto(performerId: String, completion: @escaping (Data?) -> Void)
    func acceptPerformerToWork(workId: String, performerId: String, completion: @escaping (EmassiApiResponse?, Error?) -> Void)
    func sendMessageToPerformer(workId: String, performerId: String, completion: @escaping (EmassiApiResponse?, Error?) -> Void)
}

class ActiveWorksInteractor: ActiveWorksInteractorDelegate{
    var emassiApi: EmassiApi
    
    init(emassiApi: EmassiApi) {
        self.emassiApi = emassiApi
    }
    
    func getCategoryName(categoryId: String, completion: @escaping (String?) -> Void){
        emassiApi.getCategoryInfo(category: categoryId) { category, _, _ in
            completion(category?.name)
        }
    }
    
    func getPerformerPhoto(performerId: String, completion: @escaping (Data?) -> Void){
        emassiApi.downloadPerformerPhotoPublic(performerId: performerId) { data, _ in
            completion(data)
        }
    }
    
    func getPerformersForWork(workId: String, completion: @escaping ([PerformerForWork]) -> Void){
        emassiApi.getPerformersForWork(workId: workId) { performers, apiResponse, error in
            completion(performers)
        }
    }
    
    func acceptPerformerToWork(workId: String, performerId: String, completion: @escaping (EmassiApiResponse?, Error?) -> Void) {
        emassiApi.acceptPerformerForWork(workId: workId, performerId: performerId, completion: completion)
    }
    
    func sendMessageToPerformer(workId: String, performerId: String, completion: @escaping (EmassiApiResponse?, Error?) -> Void) {
        
    }
    
    func deleteWork(workId: String, completion: @escaping (EmassiApiResponse?, Error?) -> Void){
        emassiApi.deleteWork(workId: workId, completion: completion)
    }
    
    func getWorks(active: Bool, completion: @escaping (_ works: [WorkActive], EmassiApiResponse?, Error?) -> Void){
        emassiApi.getMyActiveWorks(active: active) { activeWorks, apiResponse, error in
            completion(activeWorks,apiResponse,error)
        }
    }
}
