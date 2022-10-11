//
//  OrdersListInteractor.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 04.10.2022.
//

import Foundation
protocol OrdersListInteractorDelegate: AnyObject{
    func getAllWorks(active: Bool, type: DocumentType,date: Date?, completion: @escaping ([AllWork], EmassiApiResponse?, Error?) ->Void)
    func downloadCustomerPhoto(photoId: String, completion: @escaping (Data?) -> Void)
    func getCategoryName(categoryId: String, completion: @escaping (String?) -> Void)
    func getWorkInfo(workId: String, completion: @escaping (_ work: WorkWithCustomer?, EmassiApiResponse?, Error?) -> Void)
}

class OrdersListInteractor: OrdersListInteractorDelegate{
    var emassiApi: EmassiApi
    init(emassiApi: EmassiApi) {
        self.emassiApi = emassiApi
    }
    
    func getAllWorks(active: Bool, type: DocumentType,date: Date?, completion: @escaping ([AllWork], EmassiApiResponse?, Error?) -> Void) {
        emassiApi.getAllWorks(active: active, type: type.rawValue,startDate: date, completion: completion)
    }
    
    func getCategoryName(categoryId: String, completion: @escaping (String?) -> Void){
        emassiApi.getCategoryInfo(category: categoryId) { subCategory, _, _ in
            completion(subCategory?.name)
        }
    }
    
    func downloadCustomerPhoto(photoId: String, completion: @escaping (Data?) -> Void){
        emassiApi.downloadCustomerPhotoPublic(customerId: photoId) { data, _ in
            completion(data)
        }
    }
    
    func getWorkInfo(workId: String, completion: @escaping (_ work: WorkWithCustomer?, EmassiApiResponse?, Error?) -> Void){
        emassiApi.getWorkInfoForMe(workId: workId, completion: completion)
    }
    
}
