//
//  FavoriteInteractor.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 09.10.2022.
//

import Foundation
protocol FavoriteInteractorDelegate: AnyObject{
    func getFavoritesPerformers(completion: @escaping ([PerformerInfo]) -> Void)
    func removePerformersFromFavorites(performers: [String], completion: @escaping (_ existsPerformers: [String]) -> Void)
    func getPerformerPhoto(performerId: String, completion: @escaping (Data?) -> Void)
}
class FavoriteInteractor: FavoriteInteractorDelegate{
    var emassiApi: EmassiApi
    var favoritePerformers: [String] = []
    init(emassiApi: EmassiApi) {
        self.emassiApi = emassiApi
    }
    
    func removePerformersFromFavorites(performers: [String], completion: @escaping (_ existsPerformers: [String]) -> Void){
        DispatchQueue.global().async { [weak self] in
            guard let self = self else {
                completion(self?.favoritePerformers ?? [])
                return
            }
            self.favoritePerformers.removeAll { performer in
                performers.contains(where: {
                    $0 == performer
                })
            }
            UserDefaults.standard.set(self.favoritePerformers, forKey: UserDefaults.favoritesPerformersKey)
            completion(self.favoritePerformers)
        }
    }
    
    func getFavoritesPerformers(completion: @escaping ([PerformerInfo]) -> Void){
        DispatchQueue.global(qos: .utility).async {
            var allPerformers: [PerformerInfo] = []
            if let favoritesPerformers = UserDefaults.standard.stringArray(forKey: UserDefaults.favoritesPerformersKey){
                self.favoritePerformers = favoritesPerformers
                let getAllPerformersInfoOperation = OperationQueue()
                let acceptOperationQueue = OperationQueue()
                acceptOperationQueue.maxConcurrentOperationCount = 1
                
                for performerId in favoritesPerformers {
                    let getPerformerInfoOperation = AsyncBlockOperation()
                    getPerformerInfoOperation.action = { [weak self] in
                        DispatchQueue.main.async { [weak self] in
                            self?.getPerformerInfo(performerId: performerId, completion: { [weak getPerformerInfoOperation, weak acceptOperationQueue] performerInfo in
                                getPerformerInfoOperation?.finish()
                                if let performerInfo = performerInfo{
                                    acceptOperationQueue?.addOperation {
                                        allPerformers.append(performerInfo)
                                    }
                                }
                            })
                        }
                    }
                    getAllPerformersInfoOperation.addOperation(getPerformerInfoOperation)
                }
                
                getAllPerformersInfoOperation.waitUntilAllOperationsAreFinished()
                acceptOperationQueue.waitUntilAllOperationsAreFinished()
            }
            completion(allPerformers)
        }
    }
    
    func getPerformerPhoto(performerId: String, completion: @escaping (Data?) -> Void){
        emassiApi.downloadPerformerPhotoPublic(performerId: performerId) { data, _ in
            completion(data)
        }
    }
    
    func getPerformerInfo(performerId: String, completion: @escaping (PerformerInfo?) -> Void){
        emassiApi.getPerformerProfileByIdPublic(performerId: performerId) {  performerInfo, apiResponse, error in
            completion(performerInfo)
        }
    }
}
