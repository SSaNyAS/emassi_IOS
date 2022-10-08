//
//  PerformerInfoInteractor.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 23.09.2022.
//

import Foundation
protocol PerformerInfoInteractorDelegate{
    func getPerformerInfo(performerId: String, completion: @escaping (PerformerInfo?,EmassiApiResponse?) -> Void)
    func getPerformerPhoto(performerId: String, completion: @escaping (Data?) -> Void)
}

class PerformerInfoInteractor: PerformerInfoInteractorDelegate{
    weak var emassiApi: EmassiApi?
    init(emassiApi: EmassiApi) {
        self.emassiApi = emassiApi
    }
    func getPerformerPhoto(performerId: String, completion: @escaping (Data?) -> Void) {
        emassiApi?.downloadPerformerPhotoPublic(performerId: performerId, completion: { data, _ in
            completion(data)
        })
    }
    
    func getPerformerInfo(performerId: String, completion: @escaping (PerformerInfo?,EmassiApiResponse?) -> Void) {
        emassiApi?.getPerformerProfileByIdPublic(performerId: performerId, completion: { performer, apiResponse, error in
            completion(performer,apiResponse)
        })
    }
}
