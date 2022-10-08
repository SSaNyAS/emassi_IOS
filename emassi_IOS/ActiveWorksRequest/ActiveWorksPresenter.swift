//
//  ActiveWorksPresenter.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 04.10.2022.
//

import Foundation
protocol ActiveWorksPresenterDelegate: AnyObject{
    func viewDidLoad()
    func loadWorks()
}

class ActiveWorksPresenter: ActiveWorksPresenterDelegate{
    var interactor: ActiveWorksInteractorDelegate
    weak var router: RouterDelegate?
    weak var viewDelegate: ActiveWorksViewDelegate?
    var tableViewWorker: ActiveWorksTableViewDataUIWorker
    
    init(interactor: ActiveWorksInteractorDelegate) {
        self.interactor = interactor
        tableViewWorker = .init()
        tableViewWorker.getCategoryNameAction = { [weak self] categoryId , completion in
            self?.getCategoryName(categoryId: categoryId, completion: completion)
        }
        tableViewWorker.getPerformerPhoto = { [weak self] performerId, completion in
            self?.getPerformerPhoto(performerId: performerId, completion: completion)
        }
        tableViewWorker.didCancelWorkAction = { [weak self] workId, completion in
            self?.deleteWork(workId: workId, completion: { [weak self] isSuccess in
                self?.viewDelegate?.showMessage(message: "Задание успешно отменено", title: "")
                self?.viewDidLoad()
            })
        }
        tableViewWorker.didAcceptPerformerAction = { [weak self] workId, performerId in
            self?.acceptPerformerToWork(workId: workId, performerId: performerId, completion: { [weak self] isSuccess in
                self?.viewDelegate?.showMessage(message: "Исполнитель успешно назначен", title: "")
                self?.viewDidLoad()
            })
        }
        tableViewWorker.didSendMessageToPerformerAction = { [weak self] workId, performerId in
            self?.sendMessageToPerformer(workId: workId, performerId: performerId, completion: { _ in
                
            })
        }
    }
    
    func loadWorks() {
        interactor.getWorks(active: true) { [weak self] works, apiResponse, error in
            DispatchQueue.global().async {
                var works = works
                if works.isEmpty{
                    self?.viewDelegate?.setEmptyListView()
                } else {
                    let acceptQueue = OperationQueue()
                    acceptQueue.maxConcurrentOperationCount = 1
                    
                    let getPerformesQueue = OperationQueue()
                    getPerformesQueue.name = "getPerformersForWork"
                    for workNum in 0..<works.count{
                        let work = works[workNum]
                        let getPerformersOperation = AsyncBlockOperation()
                        
                        getPerformersOperation.action = { [weak self] in
                            DispatchQueue.main.async {
                                print("gaggg")
                                self?.getPerformersForWork(workId: work.workId, completion: { performers in
                                    acceptQueue.addOperation{
                                        works[workNum].performersList = performers
                                    }
                                    getPerformersOperation.finish()
                                })
                            }
                        }
                        getPerformesQueue.addOperation(getPerformersOperation)
                    }
                    getPerformesQueue.waitUntilAllOperationsAreFinished()
                    acceptQueue.waitUntilAllOperationsAreFinished()
                }
                
                self?.tableViewWorker.works = works
                if let tableViewWorker = self?.tableViewWorker{
                    self?.viewDelegate?.setTableViewDataSource(dataSource: tableViewWorker)
                    self?.viewDelegate?.setTableViewDelegate(delegate: tableViewWorker)
                    self?.viewDelegate?.reloadTableViewData()
                }
            }
        }
    }
    
    func deleteWork(workId: String, completion: @escaping (Bool) -> Void){
        interactor.deleteWork(workId: workId) { apiResponse, error in
            completion(error == nil && (apiResponse?.isErrored == false))
        }
    }
    
    func acceptPerformerToWork(workId: String, performerId: String, completion: @escaping (Bool) ->Void){
        interactor.acceptPerformerToWork(workId: workId, performerId: performerId) { apiResponse, error in
            completion(error == nil && (apiResponse?.isErrored == false))
        }
    }
    
    func sendMessageToPerformer(workId: String, performerId: String, completion: @escaping (Bool) ->Void){
        interactor.sendMessageToPerformer(workId: workId, performerId: performerId) { apiResponse, error in
            completion(error == nil && (apiResponse?.isErrored == false))
        }
    }
    
    func getCategoryName(categoryId: String, completion: @escaping (String?) -> Void){
        interactor.getCategoryName(categoryId: categoryId, completion: completion)
    }
    
    func getPerformerPhoto(performerId: String, completion: @escaping (Data?) -> Void){
        interactor.getPerformerPhoto(performerId: performerId, completion: completion)
    }
    
    func getPerformersForWork(workId: String, completion: @escaping ([PerformerForWork]) -> Void){
        interactor.getPerformersForWork(workId: workId, completion: completion)
    }
    
    func viewDidLoad() {
        loadWorks()
    }
    
}
