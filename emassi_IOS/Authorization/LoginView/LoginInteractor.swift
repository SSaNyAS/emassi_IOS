//
//  LoginInteractor.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 08.09.2022.
//

import Foundation
protocol LoginInteractorProtocol{
    func isValidLogin(login: String) -> Bool
    func login(login: String, password: String, completion: (Bool) -> Void)
}

class LoginInteractor: LoginInteractorProtocol{
    weak var loginPresenter: LoginPresenterProtocol?
    var api: EmassiApiDelegate
    
    init(api: EmassiApiDelegate){
        self.api = api
    }
    
    func isValidLogin(login: String) -> Bool {
        return login.isEmail()
    }
    
    func login(login: String, password: String, completion: (Bool) -> Void) {
        completion(false)
    }
    
}
