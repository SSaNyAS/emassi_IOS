//
//  CalendarInteractor.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 16.10.2022.
//

import Foundation
protocol CalendarInteractorDelegate: AnyObject{
    func getAllWorks(active: Bool, type: DocumentType, date: Date?, completion: @escaping (_ works: [AllWork],_ message: String?) -> Void)
}

class CalendarInteractor: CalendarInteractorDelegate{
    var emassiApi: EmassiApi
    init(emassiApi: EmassiApi) {
        self.emassiApi = emassiApi
    }
    
    func getAllWorks(active: Bool, type: DocumentType, date: Date?, completion: @escaping (_ works: [AllWork],_ message: String?) -> Void){
        emassiApi.getAllWorks(active: active, type: type.rawValue,startDate: date, completion: { works, apiResponse, error in
            completion(works,error?.localizedDescription ?? apiResponse?.message)
        })
    }
}
