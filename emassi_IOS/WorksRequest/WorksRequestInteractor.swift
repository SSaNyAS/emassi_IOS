//
//  WorksRequestInteractor.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 29.09.2022.
//

import Foundation
protocol WorksRequestInteractorDelegate{
    func getAllWorks(active: Bool, type: DocumentType, date: Date?, completion: @escaping (_ works: [AllWork],_ message: String?) -> Void)
    func getWorksRequests(completion: @escaping (_ works: [Work],_ message: String?) -> Void)
    func getActiveWorks(completion: @escaping (_ works: [Work],_ message: String?) -> Void)
    func getAccountInfo(completion: @escaping (_ accountInfo: AccountInfoModel?,_ message: String?) -> Void)
    func sendWorkStatus(workId: String, status: WorkStatus, completion: @escaping (_ apiResponse: EmassiApiResponse?, _ error: Error?) -> Void)
    func getCategoryName(categoryId: String, completion: @escaping (String?) -> Void)
}

class WorksRequestInteractor: WorksRequestInteractorDelegate {
    weak var emassiApi: EmassiApi?
    
    init(emassiApi: EmassiApi) {
        self.emassiApi = emassiApi
    }
    
    func sendWorkStatus(workId: String, status: WorkStatus, completion: @escaping (_ apiResponse: EmassiApiResponse?, _ error: Error?) -> Void){
        emassiApi?.changeWorkStatus(workId: workId, action: status, completion: completion)
    }
    
    func getCategoryName(categoryId: String, completion: @escaping (String?) -> Void){
        emassiApi?.getCategoryInfo(category: categoryId, completion: { category, _, _ in
            completion(category?.name)
        })
    }
    
    func getWorksRequests(completion: @escaping (_ works: [Work],_ message: String?) -> Void){
        emassiApi?.getMyWorksRequests(active: true, completion: { works, apiResponse, error in
            completion(works, error?.localizedDescription ?? apiResponse?.message)
        })
    }
    
    func getActiveWorks(completion: @escaping (_ works: [Work],_ message: String?) -> Void){
        emassiApi?.getMyWorksRequests(active: true, completion: { works, apiResponse, error in
            completion(works,error?.localizedDescription ?? apiResponse?.message)
        })
    }
    
    func getAccountInfo(completion: @escaping (_ accountInfo: AccountInfoModel?,_ message: String?) -> Void){
        emassiApi?.getAccountInfo(completion: { accountInfo, apiResponse, error in
            completion(accountInfo, error?.localizedDescription ?? apiResponse?.message)
        })
    }
    
    func getAllWorks(active: Bool, type: DocumentType, date: Date?, completion: @escaping (_ works: [AllWork],_ message: String?) -> Void){
        emassiApi?.getAllWorks(active: active, type: type.rawValue,startDate: date, completion: { works, apiResponse, error in
            completion(works,error?.localizedDescription ?? apiResponse?.message)
        })
    }
}
