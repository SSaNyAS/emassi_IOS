//
//  PerformersListInteractor.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 23.09.2022.
//

import Foundation
protocol PerformersListInteractorDelegate{
    func getPerformersList(category: String, completion: @escaping (_ performers: [PerformerForList],_ apiResponse: EmassiApiResponse?) -> Void)
    func getCategoryInfo(category: String, completion:@escaping (_ categoryName: String?) -> Void)
}

class PerformersListInteractor: PerformersListInteractorDelegate{
    weak var emassiApi: EmassiApi?
    init(emassiApi: EmassiApi) {
        self.emassiApi = emassiApi
    }
    
    func getCategoryInfo(category: String, completion:@escaping (_ categoryName: String?) -> Void){
        emassiApi?.getPerformersCategories(completion: { categories, apiResponse, error in
                    
            let allSubCategories = categories.map({$0.subCategories})
            
            for subCategories in allSubCategories{
                let subcategory = subCategories.first { subCat in
                    subCat.value == category
                }
                if let subcategory = subcategory{
                    completion(subcategory.name)
                    return
                }
            }
            completion(nil)
        })
    }
    
    func getPerformersList(category: String, completion: @escaping (_ performers: [PerformerForList], _ apiResponse: EmassiApiResponse?) -> Void) {
        emassiApi?.getPerformersListByCategory(category: category, completion: { performers, apiResponse, error in
            completion(performers,apiResponse)
        })
    }
}
