//
//  LoginPresenter.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 08.09.2022.
//

import Foundation

protocol LoginPresenterProtocol: NSObject{
    var loginView: LoginViewDelegate?{get set}
    func didInit()
    func login(login: String?, password: String?)
    func setError(message: String)
    func goToRegister()
    func goToResetPassword()
}

class LoginPresenter:NSObject, LoginPresenterProtocol{
    private var interactor: LoginInteractorProtocol
    weak var loginView: LoginViewDelegate?
    weak var router: RouterDelegate?
    
    init(interactor: LoginInteractorProtocol,router: RouterDelegate?){
        self.interactor = interactor
        self.router = router
        super.init()
    }
    
    func login(login: String?, password: String?) {
        guard
            let login = login?.trimmingCharacters(in: .whitespacesAndNewlines),
            let password = password?.trimmingCharacters(in: .whitespacesAndNewlines),
            !login.isEmpty,
            !password.isEmpty else {
        
            loginView?.showMessage(message: "login or password is empty")
            return
        }
        guard interactor.isValidLogin(login: login) else {
            loginView?.showMessage(message: "invalid login format")
            return
        }
        
        interactor.login(email: login, password: password) { [weak self] isSuccess, message  in
            if isSuccess{
                if let viewController = self?.loginView?.getViewController(){
                    self?.router?.goToViewController(from: viewController, to: .categories, presentationMode: .presentFullScreen)
                }
            } else{
                self?.loginView?.showMessage(message: message)
            }
        }
    }
    
    func goToRegister() {
        if let viewController = loginView?.getViewController(){
                router?.goToViewController(from: viewController, to: .register, presentationMode: .present)
        }
    }
    
    func goToResetPassword() {
        if let viewController = loginView?.getViewController(){
                router?.goToViewController(from: viewController, to: .resetPassword, presentationMode: .present)
        }
    }
    func didInit() {
        if interactor.isValidToken(){
            if let viewController = loginView?.getViewController(){
                router?.goToViewController(from: viewController, to: .categories, presentationMode: .presentFullScreen)
            }
        }
    }
    
    func setError(message: String) {
        print(message)
    }
}
