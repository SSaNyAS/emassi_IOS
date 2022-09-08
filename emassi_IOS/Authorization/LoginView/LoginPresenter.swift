//
//  LoginPresenter.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 08.09.2022.
//

import Foundation
protocol LoginPresenterProtocol: NSObject{
    func login(login: String, password: String)
}

class LoginPresenter:NSObject, LoginPresenterProtocol{
    private var interactor: LoginInteractorProtocol
    init(interactor: LoginInteractorProtocol){
        self.interactor = interactor
    }
    func login(login: String, password: String) {
        interactor.login(login: login, password: password) { isSuccess in
            
        }
    }
}
