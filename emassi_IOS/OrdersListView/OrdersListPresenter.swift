//
//  OrdersListPresenter.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 04.10.2022.
//

import Foundation
protocol OrdersListPresenterDelegate: AnyObject{
    func viewDidLoad()
    func getAllWorks(date: Date?)
    func goToRegisterAsPerformer()
}

class OrdersListPresenter: OrdersListPresenterDelegate{
    var interactor: OrdersListInteractorDelegate
    var ordersListDataUIWorker:  OrdersListTableViewDataUIWorker
    weak var router: RouterDelegate?
    weak var viewDelegate: OrdersListViewDelegate?
    
    init(interactor: OrdersListInteractorDelegate) {
        self.interactor = interactor
        ordersListDataUIWorker = .init()
        ordersListDataUIWorker.getCustomerPhoto = {[weak self] photoId, completion in
            self?.interactor.downloadCustomerPhoto(photoId: photoId, completion: completion)
        }
        ordersListDataUIWorker.getCategoryNameAction = { [weak self] categoryId, completion in
            self?.interactor.getCategoryName(categoryId: categoryId, completion: completion)
        }
        ordersListDataUIWorker.getSuperCategoryNameAction = { [weak self] categoryId, completion in
            self?.interactor.getCategoryName(categoryId: categoryId, completion: completion)
        }
        ordersListDataUIWorker.didSendOfferToWorkAction = { [weak self] workId, _ in
            self?.sendOfferForWork(workId: workId)
        }
        ordersListDataUIWorker.didClickOnWorkAction = { [weak self] workId in
            if let viewController = self?.viewDelegate?.getViewController(){
                self?.router?.goToViewController(from: viewController, to: .orderInfo(workId), presentationMode: .push)
            }
        }
    }
    
    func goToRegisterAsPerformer() {
        if let viewController = viewDelegate?.getViewController(){
            router?.goToViewController(from: viewController, to: .performerProfile, presentationMode: .push)
        }
    }
    
    func viewDidLoad() {
        let date = Date()
        viewDelegate?.setDate(date: date)
        getAllWorks(date: date)
    }
    
    func getAllWorks(date: Date?) {
        interactor.getAllWorks(active: true, type: .public,date: date) { [weak self] works, ApiResponse, error in
            DispatchQueue.global(qos: .utility).async {
                let worksAll = works
                var worksToDataSource: [WorkWithCustomer] = []
                if worksAll.isEmpty{
                    self?.viewDelegate?.setEmptyListView()
                } else {
                    let acceptQueue = OperationQueue()
                    acceptQueue.maxConcurrentOperationCount = 1
                    
                    let getCustomerQueue = OperationQueue()
                    getCustomerQueue.name = "getCustomerForWork"
                    for workNum in 0..<works.count{
                        let work = works[workNum]
                        let getCustomerOperation = AsyncBlockOperation()
                        
                        getCustomerOperation.action = { [weak self] in
                            DispatchQueue.main.async {
                                self?.getWorkInfo(workId: work.id, completion: { workWithCustomer in
                                    if var workWithCustomer = workWithCustomer{
                                        acceptQueue.addOperation{
                                            workWithCustomer.myOfferToWork = work.offer
                                            worksToDataSource.append(workWithCustomer)
                                        }
                                    }
                                    getCustomerOperation.finish()
                                })
                            }
                        }
                        getCustomerQueue.addOperation(getCustomerOperation)
                    }
                    getCustomerQueue.waitUntilAllOperationsAreFinished()
                    acceptQueue.waitUntilAllOperationsAreFinished()
                }
                
                self?.ordersListDataUIWorker.works = worksToDataSource
                if let dataUIWorker = self?.ordersListDataUIWorker{
                    self?.viewDelegate?.setTableViewDataSource(dataSource: dataUIWorker)
                    self?.viewDelegate?.reloadTableViewData()
                }
            }
        }
    }
    
    func sendOfferForWork(workId: String){
        if let viewController = viewDelegate?.getViewController(){
            router?.goToViewController(from: viewController, to: .sendOfferForWork(workId), presentationMode: .present)
        }
    }
    
    func getWorkInfo(workId: String, completion: @escaping (_ workWithCustomer: WorkWithCustomer?) -> Void ){
        interactor.getWorkInfo(workId: workId) { work, apiResponse, error in
            completion(work)
        }
    }
}


