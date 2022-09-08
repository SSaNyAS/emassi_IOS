//
//  AuthorizationViewsData.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 08.09.2022.
//

import Foundation
import Combine

class AuthorizationViewsData{
    var login: CurrentValueSubject<String?,Never> = .init("")
    var password: CurrentValueSubject<String?,Never> = .init("")
    
    public func getLoginViewController(login: String? = nil,password: String? = nil) -> LoginViewController{
        let loginVC = LoginViewController()
        loginVC.loadViewIfNeeded()
        
        if let loginExist = login {
            self.login.value = loginExist
        }
        if let passwordExist = password {
            self.password.value = passwordExist
        }
        
        if let loginTextField = loginVC.loginTextField{
            self.login
                .compactMap({$0})
                .sink(receiveValue: {[weak loginTextField] value in
                    if loginTextField?.text != value{
                        loginTextField?.text = value
                    }
                })
                .store(in: &loginVC.disposeBag)
            
            loginTextField.publisher(for: \.text, options: [.prior])
                .compactMap({$0})
                .sink(receiveValue: { [weak self] value in
                    self?.login.send(value)
                })
                .store(in: &loginVC.disposeBag)
        }
        
        if let passwordTextField = loginVC.passwordTextField{
            self.password
                .compactMap({$0})
                .sink(receiveValue: {[weak passwordTextField] value in
                    if passwordTextField?.text != value{
                        passwordTextField?.text = value
                    }
                })
                .store(in: &loginVC.disposeBag)
            
            passwordTextField.publisher(for: \.text, options: [.prior])
                .compactMap({$0})
                .sink(receiveValue: { [weak self] value in
                    self?.password.send(value)
                })
                .store(in: &loginVC.disposeBag)
        }
        
        loginVC.authorizationViews = self
        return loginVC
    }
    
    public func getRegisterViewController(login: String? = nil,password: String? = nil) -> RegisterViewController{
        let registerVC = RegisterViewController()
        registerVC.loadViewIfNeeded()
        
        if let loginExist = login {
            self.login.value = loginExist
        }
        if let passwordExist = password {
            self.password.value = passwordExist
        }
        
        if let loginTextField = registerVC.loginTextField{
            self.login
                .compactMap({$0})
                .sink(receiveValue: {[weak loginTextField] value in
                    if loginTextField?.text != value{
                        loginTextField?.text = value
                    }
                })
                .store(in: &registerVC.disposeBag)
            
            loginTextField.publisher(for: \.text, options: [.prior])
                .compactMap({$0})
                .sink(receiveValue: { [weak self] value in
                    self?.login.send(value)
                })
                .store(in: &registerVC.disposeBag)
        }
        
        if let passwordTextField = registerVC.passwordTextField{
            self.password
                .compactMap({$0})
                .sink(receiveValue: {[weak passwordTextField] value in
                    if passwordTextField?.text != value{
                        passwordTextField?.text = value
                    }
                })
                .store(in: &registerVC.disposeBag)
            
            passwordTextField.publisher(for: \.text, options: [.prior])
                .compactMap({$0})
                .sink(receiveValue: { [weak self] value in
                    self?.password.send(value)
                })
                .store(in: &registerVC.disposeBag)
        }
        
        registerVC.authorizationView = self
        return registerVC
    }
}
