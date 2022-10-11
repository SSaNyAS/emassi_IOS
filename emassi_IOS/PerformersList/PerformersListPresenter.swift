//
//  PerformersListPresenter.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 22.09.2022.
//

import Foundation
protocol PerformersListPresenterDelegate: NSObject{
    func loadPerformers(completion: @escaping (Bool)->Void)
    func createOrder()
}
class PerformersListPresenter:NSObject, PerformersListPresenterDelegate{
    var interactor: PerformersListInteractorDelegate
    weak var router: RouterDelegate?
    weak var viewDelegate: PerformersListViewDelegate?
    var category: String
    var dataSourceAndDelegate: PerformersListDataSourceAndDelegate
    
    init(interactor: PerformersListInteractorDelegate, category: String) {
        self.interactor = interactor
        self.category = category
        let dataSourceDelegate = PerformersListDataSourceAndDelegate()
        self.dataSourceAndDelegate = dataSourceDelegate
        super.init()
        dataSourceDelegate.didSelectAction = { [weak self] performer in
            self?.didSelectPerformer(performerId: performer.id)
        }
        dataSourceDelegate.imageDownloadAction = { [weak self] performer, completion in
            self?.interactor.downloadPerformerPhoto(performerId: performer.id) { imageData, apiResponse in
                completion(imageData)
            }
        }
        getCategoryInfo { categoryName in
            dataSourceDelegate.category = categoryName
        }
    }
    
    func didSelectPerformer(performerId: String){
        if let viewController = viewDelegate?.getViewController(){
            router?.goToViewController(from: viewController, to: .performerInfo(performerId), presentationMode: .push)
        }
    }
    
    func getCategoryInfo(completion: @escaping (String?) -> Void){
        interactor.getCategoryInfo(category: category) {categoryName in
            completion(categoryName)
        }
    }
    
    func createOrder() {
        if let viewController = viewDelegate?.getViewController(){
            router?.goToViewController(from: viewController, to: .createRequest("", category), presentationMode: .present)
        }
    }
    
    func loadPerformers(completion: @escaping (Bool) -> Void) {
        interactor.getPerformersList(category: category) {[weak self] performers, apiResponse in
            self?.dataSourceAndDelegate.performers = performers
            if let dataSource = self?.dataSourceAndDelegate{
                self?.viewDelegate?.setTableViewDelegate(delegate: dataSource)
                self?.viewDelegate?.setTableViewDataSource(dataSource: dataSource)
            }
            completion(!(apiResponse?.isErrored ?? true))
        }
    }
}
