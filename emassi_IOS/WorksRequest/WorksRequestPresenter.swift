//
//  WorksRequestPresenter.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 29.09.2022.
//

import Foundation
protocol WorksRequestPresenterDelegate: AnyObject{
    func viewDidLoad()
    func getAllWorks()
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
    }
    
    func viewDidLoad() {
        getAccountInfo { [weak self] IsNeedsToLoadData in
            if IsNeedsToLoadData{
                self?.getAllWorks()
            }
        }
    }
    
    func getAllWorks(){
        interactor.getAllWorks(active: true, type: .public, date: nil) {[weak self] works, message in
            self?.worksDataSource.works = works
            if let worksDataSource = self?.worksDataSource{
                self?.viewDelegate?.setTableViewDataSource(dataSource: worksDataSource)
                self?.viewDelegate?.reloadTableViewData()
            }
            if works.isEmpty{
                self?.viewDelegate?.setEmptyListView()
            } else {
                self?.viewDelegate?.removeBackgroundViews()
            }
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
