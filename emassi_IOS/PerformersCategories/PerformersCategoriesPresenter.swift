//
//  PerformersCategoriesPresenter.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 22.09.2022.
//

import Foundation

protocol PerformersCategoriesPresenterDelegate: NSObject{
    func getCategories()
    func didChangeSearchText(searchText: String)
}

class PerformersCategoriesPresenter: NSObject, PerformersCategoriesPresenterDelegate{
    var interactor: PerformersCategoriesInteractorDelegate
    weak var viewDelegate: PerformersCategoriesViewDelegate?
    weak var router: RouterDelegate?
    let dataSource: PerformersCategoriesTableViewDataSourceDelegate
    
    init(interactor: PerformersCategoriesInteractorDelegate) {
        self.interactor = interactor
        dataSource = PerformersCategoriesTableViewDataSourceDelegate()
        super.init()
        dataSource.didSelectCategoryAction = { [weak self] in
            self?.didSelectCategory(category: $0)
        }
    }
    
    func didSelectCategory(category: String){
        if let viewController = viewDelegate?.getViewController(){
            router?.goToViewController(from: viewController, to: .performersList(category), presentationMode: .push)
        }
    }
    
    func didChangeSearchText(searchText: String) {
        dataSource.searchAndScroollToRow(searchText: searchText)
    }
    
    func getCategories() {
        interactor.getCategories { [weak self] categories in
            self?.dataSource.performersCategories = categories
            if let dataSourceAndDelegate = self?.dataSource{
                self?.viewDelegate?.setDataSource(dataSource: dataSourceAndDelegate)
                self?.viewDelegate?.setTableViewDelegate(delegate: dataSourceAndDelegate)
                self?.viewDelegate?.reloadTableViewData()
            }
        }
        
    }
}
