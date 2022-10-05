//
//  OrdersListPresenter.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 04.10.2022.
//

import Foundation
protocol OrdersListPresenterDelegate: AnyObject{
    func viewDidLoad()
    func getAllWorks()
}

class OrdersListPresenter: OrdersListPresenterDelegate{
    var interactor: OrdersListInteractorDelegate
    init(interactor: OrdersListInteractorDelegate) {
        self.interactor = interactor
    }
    
    func viewDidLoad() {
        
    }
    
    func getAllWorks() {
        interactor.getAllWorks(active: true, type: .public) { works, ApiResponse, error in
            
        }
    }
}


