//
//  WorksRequestPresenter.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 29.09.2022.
//

import Foundation
protocol WorksRequestPresenterDelegate: AnyObject{
    func viewDidLoad(date: Date?)
    func getAllWorks(date: Date?)
    func goToRegisterAsPerformer()
}

class WorksRequestPresenter: WorksRequestPresenterDelegate{
    var interactor: WorksRequestInteractorDelegate
    var worksDataSource: WorksRequestTableViewDataSource
    weak var router: RouterDelegate?
    weak var viewDelegate: WorksRequestViewDelegate?
    
    init(interactor: WorksRequestInteractorDelegate) {
        self.interactor = interactor
        worksDataSource = .init()
        worksDataSource.sendWorkStatus = { [weak self] workId, workStatus, completion in
            self?.sendWorkStatus(workId: workId, status: workStatus, completion: completion)
        }
        worksDataSource.didSelectWork = { [weak self] workId in
            if let viewController = self?.viewDelegate?.getViewController(){
                self?.router?.goToViewController(from: viewController, to: .orderInfo(workId), presentationMode: .push)
            }
        }
        worksDataSource.getCategoryNameAction = { [weak self] categoryId, completion in
            self?.interactor.getCategoryName(categoryId: categoryId, completion: completion)
        }
        worksDataSource.getSuperCategoryNameAction = { [weak self] categoryId, completion in
            self?.interactor.getCategoryName(categoryId: categoryId, completion: completion)
        }
    }
    
    func viewDidLoad(date: Date? = nil) {
        getAccountInfo { [weak self] IsNeedsToLoadData in
            if IsNeedsToLoadData{
                self?.getAllWorks(date: date)
            }
        }
    }
    
    func getAllWorks(date: Date?){
        DispatchQueue.global(qos: .utility).async { [weak self] in
            let getAllWorksTypeOperationQueue = OperationQueue()
            getAllWorksTypeOperationQueue.maxConcurrentOperationCount = 2
            
            let acceptWorksOperationQueue = OperationQueue()
            acceptWorksOperationQueue.maxConcurrentOperationCount = 1
            
            var allTypesWorks: [AllWork] = []
            let getPublicWorksOperation = AsyncBlockOperation()
            getPublicWorksOperation.action = { [weak self] in
                self?.interactor.getAllWorks(active: true, type: .public, date: date) {works, message in
                    acceptWorksOperationQueue.addOperation{
                        allTypesWorks.append(contentsOf: works)
                    }
                    getPublicWorksOperation.finish()
                }
            }
            let getPrivateWorksOperation = AsyncBlockOperation()
            getPrivateWorksOperation.action = { [weak self] in
                self?.interactor.getAllWorks(active: true, type: .private, date: date) {works, message in
                    acceptWorksOperationQueue.addOperation{
                        allTypesWorks.append(contentsOf: works)
                    }
                    getPrivateWorksOperation.finish()
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
    
    func sendWorkStatus(workId: String, status: WorkStatus, completion: @escaping (Bool) -> Void){
        interactor.sendWorkStatus(workId: workId, status: status) { apiResponse, error in
            completion(error == nil && (apiResponse?.isErrored == false))
        }
    }
    
    func goToRegisterAsPerformer() {
        if let viewController = viewDelegate?.getViewController(){
            router?.goToViewController(from: viewController, to: .performerProfile, presentationMode: .push)
        }
    }
    
    func getAccountInfo(completion: @escaping (_ IsNeedsToLoadData: Bool) -> Void){
        interactor.getAccountInfo { [weak self] accountInfo, message in
            var isNeedToLoadData = false
            if let accountInfo = accountInfo{
                if accountInfo.performer.active{
                    self?.viewDelegate?.setEmptyListView()
                    isNeedToLoadData = true
                } else {
                    self?.viewDelegate?.setGoToRegisterAccountView()
                    isNeedToLoadData = false
                }
            } else {
                self?.viewDelegate?.setGoToRegisterAccountView()
            }
            completion(isNeedToLoadData)
        }
    }
    
}
