//
//  WorksRequestInteractor.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 29.09.2022.
//

import Foundation
protocol WorksRequestInteractorDelegate{
    func getAllWorks(completion: @escaping (_ works: [AllWork],_ message: String?) -> Void)
}

class WorksRequestInteractor: WorksRequestInteractorDelegate {
    weak var emassiApi: EmassiApi?
    
    init(emassiApi: EmassiApi) {
        self.emassiApi = emassiApi
    }
    
    func getAllWorks(completion: @escaping (_ works: [AllWork],_ message: String?) -> Void){
        emassiApi?.getAllWorks(active: true, type: "public", completion: { works, apiResponse, error in
            completion(works ?? [],error?.localizedDescription ?? apiResponse?.message)
        })
    }
}
