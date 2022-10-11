//
//  OrderInfoInteractor.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 10.10.2022.
//

import Foundation
protocol OrderInfoInteractorDelegate: AnyObject{
    func getWorkInfo(workId: String, completion: @escaping (WorkWithCustomer?, EmassiApiResponse?, Error?) -> Void)
    func createRoute(address: Address)
    func downloadWorkImages(workId: String, imagesId: [String], completion: @escaping ([Data]) -> Void)
    func downloadWorkImages(workId: String, completion: @escaping ([Data]) -> Void)
    func downloadWorkImage(workId: String, photoId: String, completion: @escaping (Data?,EmassiApiResponse?) ->Void)
    func getWorkInfoForCustomer(workId: String, completion: @escaping (WorkActive?, EmassiApiResponse?, Error?) -> Void)
}

class OrderInfoInteractor: OrderInfoInteractorDelegate{
    var emassiApi: EmassiApi
    init(emassiApi: EmassiApi) {
        self.emassiApi = emassiApi
    }
    
    func getWorkInfo(workId: String, completion: @escaping (WorkWithCustomer?, EmassiApiResponse?, Error?) -> Void){
        emassiApi.getWorkInfoForMe(workId: workId, completion: completion)
    }
    
    func getWorkInfoForCustomer(workId: String, completion: @escaping (WorkActive?, EmassiApiResponse?, Error?) -> Void){
        emassiApi.getMyActiveWorks(active: true) { activeWorks, apiResponse, error in
            let currentWork = activeWorks.first(where: {
                $0.workId == workId
            })
            completion(currentWork,apiResponse,error)
        }
    }
    
    func downloadWorkImages(workId: String, imagesId: [String], completion: @escaping ([Data]) -> Void){
            DispatchQueue.global(qos: .utility).async {
                var imagesData: [Data] = []
                let downloadOperationQueue = OperationQueue()
                let acceptOperationQueue = OperationQueue()
                acceptOperationQueue.maxConcurrentOperationCount = 1
                
                for imageId in imagesId{
                    let getImageOperation = AsyncBlockOperation()
                    getImageOperation.action = { [weak self] in
                        self?.downloadWorkImage(workId: workId, photoId: imageId, completion: { imageData, apiResponse in
                            if apiResponse?.isErrored == false{
                                if let imageData = imageData{
                                    acceptOperationQueue.addOperation{
                                        imagesData.append(imageData)
                                    }
                                }
                            }
                            getImageOperation.finish()
                        })
                    }
                }
                downloadOperationQueue.waitUntilAllOperationsAreFinished()
                acceptOperationQueue.waitUntilAllOperationsAreFinished()
                completion(imagesData)
            }
    }
    
    func downloadWorkImages(workId: String, completion: @escaping ([Data]) -> Void){
        getWorkInfo(workId: workId) { [weak self] work, _, _ in
            guard let work = work?.work else {
                completion([])
                return
            }
            DispatchQueue.global(qos: .utility).async {
                var imagesData: [Data] = []
                let downloadOperationQueue = OperationQueue()
                let acceptOperationQueue = OperationQueue()
                acceptOperationQueue.maxConcurrentOperationCount = 1
                
                for imageId in work.photos{
                    let getImageOperation = AsyncBlockOperation()
                    getImageOperation.action = { [weak self] in
                        self?.downloadWorkImage(workId: work.id, photoId: imageId, completion: { imageData, apiResponse in
                            if apiResponse?.isErrored == false{
                                if let imageData = imageData{
                                    acceptOperationQueue.addOperation{
                                        imagesData.append(imageData)
                                    }
                                }
                            }
                            getImageOperation.finish()
                        })
                    }
                }
                downloadOperationQueue.waitUntilAllOperationsAreFinished()
                acceptOperationQueue.waitUntilAllOperationsAreFinished()
                completion(imagesData)
            }
        }
    }
    
    func downloadWorkImage(workId: String, photoId: String, completion: @escaping (Data?,EmassiApiResponse?) ->Void){
        emassiApi.downloadWorkPhoto(workId: workId, photoId: photoId, completion: completion)
    }
    
    func createRoute(address: Address){
        
    }
}
