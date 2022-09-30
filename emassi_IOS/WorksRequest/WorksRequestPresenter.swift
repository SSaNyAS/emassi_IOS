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
        getAllWorks()
    }
    
    func getAllWorks(){
        interactor.getAllWorks {[weak self] works, message in
            self?.worksDataSource.works = works
            if let worksDataSource = self?.worksDataSource{
                self?.viewDelegate?.setTableViewDataSource(dataSource: worksDataSource)
                self?.viewDelegate?.reloadData()
            }
        }
    }
}
