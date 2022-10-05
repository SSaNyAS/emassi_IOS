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
    }
    
    func loadWorks() {
        interactor.getWorks(active: true) { [weak self] works, apiResponse, error in
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
                    getPerformesQueue.addOperation {
                        self?.getPerformersForWork(workId: work.workId, completion: { performers in
                            acceptQueue.addOperation{
                                works[workNum].performersList = performers
                            }
                        })
                    }
                }
                getPerformesQueue.waitUntilAllOperationsAreFinished()
            }
            self?.tableViewWorker.works = works
            if let tableViewWorker = self?.tableViewWorker{
                self?.viewDelegate?.setTableViewDataSource(dataSource: tableViewWorker)
                self?.viewDelegate?.setTableViewDelegate(delegate: tableViewWorker)
                self?.viewDelegate?.reloadTableViewData()
            }
        }
    }
    
    func getCategoryName(categoryId: String, completion: @escaping (String?) -> Void){
        interactor.getCategoryName(categoryId: categoryId, completion: completion)
    }
    
    func getPerformersForWork(workId: String, completion: @escaping ([PerformerForWork]) -> Void){
        interactor.getPerformersForWork(workId: workId, completion: completion)
    }
    
    func viewDidLoad() {
        loadWorks()
        interactor.getWorks(active: false) { works, apiResponse, error in
            let works = works
            print(works)
        }
    }
    
}
