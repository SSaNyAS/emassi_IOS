//
//  RegisterPresenter.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 12.09.2022.
//

import Foundation
protocol RegisterPresenterProtocol: NSObject{
    func register(email: String?, password: String?, passwordConfirmation: String?, eulaAccept: Bool, sendNews: Bool)
    func goToLogin()
}

class RegisterPresenter:NSObject, RegisterPresenterProtocol{
    private var interactor: RegisterInteractorProtocol
    weak var registerView: RegisterViewDelegate?
    weak var router: RouterDelegate?
    
    init(interactor: RegisterInteractor){
        self.interactor = interactor
    }
    
    func register(email: String?, password: String?, passwordConfirmation: String?, eulaAccept: Bool, sendNews: Bool) {
        guard let email = email?.trimmingCharacters(in: .whitespacesAndNewlines), !email.isEmpty else {
            registerView?.showMessage(message: "login is empty")
            return
        }
        guard let password = password?.trimmingCharacters(in: .whitespacesAndNewlines), !password.isEmpty else {
            registerView?.showMessage(message: "password is empty")
            return
        }
        guard let passwordConfirmation = passwordConfirmation?.trimmingCharacters(in: .whitespacesAndNewlines), !passwordConfirmation.isEmpty else {
            registerView?.showMessage(message: "password confirmation is empty")
            return
        }
        guard passwordConfirmation == password else {
            registerView?.showMessage(message: "passwords not equal")
            return
        }
        guard eulaAccept else {
            registerView?.showMessage(message: "accept eula")
            return
        }
        guard interactor.isValidLogin(login: email) else {
            registerView?.showMessage(message: "invalid email format")
            return
        }
        
        interactor.register(email: email, password: password, passwordConfirmation: passwordConfirmation, eulaAccept: eulaAccept, sendNews: sendNews) { [weak self] isSuccess, message in
            if isSuccess{
                if let registerVC = self?.registerView?.getViewController(){
                    self?.router?.goToViewController(from: registerVC, to: .categories, presentationMode: .custom(.fullScreen, .coverVertical))
                }
            } else{
                self?.registerView?.showMessage(message: message)
            }
        }
        
    }
    
    func goToLogin() {
        if let registerVC = registerView?.getViewController(){
            router?.goToViewController(from: registerVC, to: .login, presentationMode: .present)
        }
    }
}
