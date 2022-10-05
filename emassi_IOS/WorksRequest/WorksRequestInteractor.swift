//
//  WorksRequestInteractor.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 29.09.2022.
//

import Foundation
protocol WorksRequestInteractorDelegate{
    func getAllWorks(completion: @escaping (_ works: [AllWork],_ message: String?) -> Void)
    func getWorksRequests(completion: @escaping (_ works: [Work],_ message: String?) -> Void)
    func getActiveWorks(completion: @escaping (_ works: [Work],_ message: String?) -> Void)
    func getAccountInfo(completion: @escaping (_ accountInfo: AccountInfoModel?,_ message: String?) -> Void)
}

class WorksRequestInteractor: WorksRequestInteractorDelegate {
    weak var emassiApi: EmassiApi?
    
    init(emassiApi: EmassiApi) {
        self.emassiApi = emassiApi
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
    
    func getAllWorks(completion: @escaping (_ works: [AllWork],_ message: String?) -> Void){
        emassiApi?.getAllWorks(active: false, type: "public", completion: { works, apiResponse, error in
            completion(works,error?.localizedDescription ?? apiResponse?.message)
        })
    }
}
