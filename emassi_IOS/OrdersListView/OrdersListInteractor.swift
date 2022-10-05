//
//  OrdersListInteractor.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 04.10.2022.
//

import Foundation
protocol OrdersListInteractorDelegate: AnyObject{
    func getAllWorks(active: Bool, type: DocumentType, completion: @escaping ([AllWork], EmassiApiResponse?, Error?) ->Void)
}

class OrdersListInteractor: OrdersListInteractorDelegate{
    var emassiApi: EmassiApi
    init(emassiApi: EmassiApi) {
        self.emassiApi = emassiApi
    }
    
    func getAllWorks(active: Bool, type: DocumentType, completion: @escaping ([AllWork], EmassiApiResponse?, Error?) -> Void) {
        emassiApi.getAllWorks(active: active, type: type.rawValue, completion: completion)
    }
    
}
