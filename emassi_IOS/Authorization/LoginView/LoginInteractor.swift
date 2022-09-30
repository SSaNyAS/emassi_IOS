//
//  LoginInteractor.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 08.09.2022.
//

import Foundation
protocol LoginInteractorProtocol{
    func isValidLogin(login: String) -> Bool
    func isValidToken() -> Bool
    func login(email: String, password: String, completion: @escaping (Bool, String) -> Void)
}

class LoginInteractor: LoginInteractorProtocol{
    weak var loginPresenter: LoginPresenterProtocol?
    var api: EmassiApi
    
    init(api: EmassiApi){
        self.api = api
    }
    
    func isValidLogin(login: String) -> Bool {
        return login.isEmail()
    }
    
    func isValidToken() -> Bool{
        return api.isValidToken
    }
    
    func login(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        api.getAccountToken(email: email, password: password) { apiResponse, error in
            if !(apiResponse?.isErrored ?? true) {
                completion(true,"")
                return
            }
            completion(false, error?.localizedDescription ?? apiResponse?.message ?? "\(apiResponse?.statusMessage ?? .EMPTY_TEXT)")
        }
    }
    
}
