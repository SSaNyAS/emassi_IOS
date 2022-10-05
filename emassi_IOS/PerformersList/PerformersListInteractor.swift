//
//  PerformersListInteractor.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 23.09.2022.
//

import Foundation
protocol PerformersListInteractorDelegate: AnyObject{
    func getPerformersList(category: String, completion: @escaping (_ performers: [PerformerForList],_ apiResponse: EmassiApiResponse?) -> Void)
    func getCategoryInfo(category: String, completion:@escaping (_ categoryName: String?) -> Void)
    func downloadPerformerPhoto(performerId: String, completion: @escaping (_ imageData: Data?, _ apiResponse: EmassiApiResponse?) -> Void)
}

class PerformersListInteractor:NSObject, PerformersListInteractorDelegate{
    weak var emassiApi: EmassiApi?
    init(emassiApi: EmassiApi) {
        self.emassiApi = emassiApi
    }
    
    func downloadPerformerPhoto(performerId: String, completion: @escaping (_ imageData: Data?, _ apiResponse: EmassiApiResponse?) -> Void){
        emassiApi?.downloadPerformerPhotoPublic(performerId: performerId, completion: completion)
    }
    
    func getCategoryInfo(category: String, completion:@escaping (_ categoryName: String?) -> Void){
        emassiApi?.getCategoryInfo(category: category, completion: { category, _, _ in
            completion(category?.name)
        })
    }
    
    func getPerformersList(category: String, completion: @escaping (_ performers: [PerformerForList], _ apiResponse: EmassiApiResponse?) -> Void) {
        emassiApi?.getPerformersListByCategory(category: category, completion: { performers, apiResponse, error in
            completion(performers,apiResponse)
        })
    }
}
