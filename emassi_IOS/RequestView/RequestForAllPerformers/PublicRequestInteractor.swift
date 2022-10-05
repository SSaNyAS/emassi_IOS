//
//  PublicRequestInteractor.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 03.10.2022.
//

import Foundation
protocol PublicRequestInteractorDelegate: AnyObject{
    func getSelectableCategories(completion: @escaping (_ categories: [MoreSelectorItem], _ message: String?) -> Void)
    func createPublicRequest(completion: @escaping (_ workId: String?, EmassiApiResponse?, Error?) -> Void)
    func addPhoto(jpegData: Data)
    
}

class PublicRequestInteractor: PublicRequestInteractorDelegate{
    var emassiApi: EmassiApi
    var createdWorkId: String? = nil
    var publicWork: WorkCreate
    var workImagesData: [Data] = []
    
    init(emassiApi: EmassiApi) {
        self.emassiApi = emassiApi
        self.publicWork = .init(performerId: "", category: .init(level1: "", level2: ""), location: .init(), distance: 0, currency: "", address: .init(), geopos: .init(currentCoordinates: .init()), comments: "")
    }
    
    func addPhoto(jpegData: Data){
        workImagesData.append(jpegData)
    }
    
    func getSelectableCategories(completion: @escaping (_ categories: [MoreSelectorItem], _ message: String?) -> Void){
        
    }
    
    func createPublicRequest(completion: @escaping (_ workId: String?, EmassiApiResponse?, Error?) -> Void){
        emassiApi.addNewWork(work: publicWork) {[weak self] workId, apiResponseWorkCreate, errorAddNewWork in
            guard let self = self else {return}
            
            if let workId = workId{
                self.createdWorkId = workId
                completion(workId, apiResponseWorkCreate, errorAddNewWork)
                for imageData in self.workImagesData{
                    self.emassiApi.uploadWorkPhoto(workId: workId, photoJpeg: imageData) { apiResponse, error in
                        guard error == nil, apiResponse?.isErrored == false else {
                            completion(workId,apiResponse, error)
                            return
                        }
                    }
                }
            }
        }
    }
    
}
