//
//  CalendarPresenter.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 16.10.2022.
//

import Foundation
protocol CalendarPresenterDelegate: AnyObject{
    func viewDidLoad()
    func reloadData()
}

class CalendarPresenter: CalendarPresenterDelegate{
    var interactor: CalendarInteractorDelegate
    var worksDataSource: CalendarTableViewWorker
    weak var router: RouterDelegate?
    weak var viewDelegate: CalendarViewDelegate?
    
    init(interactor: CalendarInteractorDelegate) {
        self.interactor = interactor
        worksDataSource = .init()
    }
    
    func viewDidLoad() {
        reloadData()
    }
    
    func reloadData() {
        getAllWorks(date: nil)
    }
    
    func getAllWorks(date: Date?){
        DispatchQueue.global(qos: .utility).async { [weak self] in
            let getAllWorksTypeOperationQueue = OperationQueue()
            getAllWorksTypeOperationQueue.maxConcurrentOperationCount = 2
            
            let acceptWorksOperationQueue = OperationQueue()
            acceptWorksOperationQueue.maxConcurrentOperationCount = 1
            
            var allTypesWorks: [AllWork] = []
            let getPublicWorksOperation = AsyncBlockOperation()
            getPublicWorksOperation.action = { [weak self, weak getPublicWorksOperation] in
                self?.interactor.getAllWorks(active: true, type: .public, date: date) {works, message in
                    acceptWorksOperationQueue.addOperation{
                        allTypesWorks.append(contentsOf: works)
                    }
                    getPublicWorksOperation?.finish()
                }
            }
            let getPrivateWorksOperation = AsyncBlockOperation()
            getPrivateWorksOperation.action = { [weak self, weak getPrivateWorksOperation] in
                self?.interactor.getAllWorks(active: true, type: .private, date: date) {works, message in
                    acceptWorksOperationQueue.addOperation{
                        allTypesWorks.append(contentsOf: works)
                    }
                    getPrivateWorksOperation?.finish()
                }
            }
            
            getAllWorksTypeOperationQueue.addOperation(getPrivateWorksOperation)
            getAllWorksTypeOperationQueue.addOperation(getPublicWorksOperation)
            
            getAllWorksTypeOperationQueue.waitUntilAllOperationsAreFinished()
            acceptWorksOperationQueue.waitUntilAllOperationsAreFinished()
            
            allTypesWorks = allTypesWorks.sorted(by: {$0.type.rawValue < $1.type.rawValue})
            
            self?.worksDataSource.works = allTypesWorks
            if let worksDataSource = self?.worksDataSource{
                self?.viewDelegate?.setTableViewDataSource(dataSource: worksDataSource)
                self?.viewDelegate?.reloadTableViewData()
            }
            if allTypesWorks.isEmpty{
                self?.viewDelegate?.setEmptyListView()
            } else {
                self?.viewDelegate?.removeBackgroundViews()
            }
        }
    }
}
