//
//  ResetPasswordInteractor.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 21.09.2022.
//

import Foundation
protocol ResetPasswordInteractorDelegate{
    var emassiApi: EmassiApi?{get}
    func resetPassword(email: String, completion: @escaping (_ message: String?, _ isSuccess: Bool) -> Void)
}

class ResetPasswordInteractor: ResetPasswordInteractorDelegate{
    weak var emassiApi: EmassiApi?
    
    init(emassiApi: EmassiApi) {
        self.emassiApi = emassiApi
    }
    
    func resetPassword(email: String, completion: @escaping (_ message: String?, _ isSuccess: Bool) -> Void) {
        emassiApi?.restorePassword(email: email) { apiResponse, error in
            let isSuccess = error == nil && !(apiResponse?.isErrored ?? true)
            completion(apiResponse?.message, isSuccess)
        }
    }
}
