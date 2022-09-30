//
//  PerformersCategoriesInteractor.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 22.09.2022.
//

import Foundation

protocol PerformersCategoriesInteractorDelegate{
    func getCategories(completion:@escaping (_ categories: [PerformersCategory]) -> Void)
}

class PerformersCategoriesInteractor: PerformersCategoriesInteractorDelegate{
    weak var emassiApi: EmassiApi?
    init(emassiApi: EmassiApi) {
        self.emassiApi = emassiApi
    }
    
    func getCategories(completion:@escaping (_ categories: [PerformersCategory]) -> Void) {
        emassiApi?.getPerformersCategories(completion: { categories, apiResponse, error in
            completion(categories)
        })
    }
}
