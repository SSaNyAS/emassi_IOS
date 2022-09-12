//
//  RegisterInteractor.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 12.09.2022.
//

import Foundation
protocol RegisterInteractorProtocol{
    func isValidLogin(login: String) -> Bool
    func register(email: String, password: String, passwordConfirmation: String, eulaAccept: Bool, sendNews: Bool, completion: @escaping (Bool, String) -> Void)
}

class RegisterInteractor: RegisterInteractorProtocol{
    
    weak var registerPresenter: RegisterPresenterProtocol?
    var api: EmassiApi
    
    init(api: EmassiApi){
        self.api = api
    }
    
    func isValidLogin(login: String) -> Bool {
        return login.isEmail()
    }
    
    func register(email: String, password: String, passwordConfirmation: String, eulaAccept: Bool, sendNews: Bool, completion: @escaping (Bool, String) -> Void) {
        let lang = Locale.current.languageCode ?? "en"
        api.registerAndGetToken(email: email, password: password, lang: lang) { apiResponse, error in
            if apiResponse?.statusMessage == .NO_ERRORS {
                completion(true,"")
                return
            }
            completion(false, error?.localizedDescription ?? apiResponse?.message ?? "\(apiResponse?.statusMessage ?? .EMPTY_TEXT)")
        }
    }
}
