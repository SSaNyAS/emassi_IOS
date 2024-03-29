//
//  LoginViewController.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 02.09.2022.
//

import Foundation
import UIKit
import Combine
protocol LoginViewDelegate: NSObject{
    func showMessage(message: String)
    func getViewController() -> UIViewController
}

class LoginViewController: UIViewController, LoginViewDelegate{
    
    func getViewController() -> UIViewController {
        return self
    }
    
    
    weak var welcomeLabel: UILabel?
    weak var messageLabel: UILabel?
    weak var loginTextField: UITextField?
    weak var passwordTextField: UITextField?
    weak var rememberPasswordChecker: UISwitch?
    weak var loginButton: UIButton?
    weak var goRegisterButton: UIButton?
    weak var resetPasswordButton: UIButton?
    weak var authorizationViews: AuthorizationViewsData?
    var presenter: LoginPresenterProtocol?{
        didSet{
            presenter?.loginView = self
            presenter?.didInit()
        }
    }
    var disposeBag: Set<AnyCancellable> = []
    
    deinit{
        disposeBag.forEach({
            $0.cancel()
        })
        disposeBag.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        view.backgroundColor = .systemBackground
        setupViews()
    }
    
    func setupViews(){
        setupWelcomeLabel()
        setupMessageLabel()
        setupLoginTextField()
        setupPasswordTextField()
        setupRememberPasswordChecker()
        setupLoginButton()
        setupGoRegisterButton()
        setupResetPasswordLabel()
        
        welcomeLabel?.text = "Приветствуем в Emassi!"
        messageLabel?.text = "Войдите в аккаунт"
        loginTextField?.placeholder = "Электронная почта или телефон"
        passwordTextField?.placeholder = "Пароль"
        
        loginButton?.setTitle("Войти", for: .normal)
        loginButton?.addTarget(self, action: #selector(loginButtonClick), for: .touchUpInside)
        
        goRegisterButton?.setTitle("Зарегистрироваться в Emassi", for: .normal)
        goRegisterButton?.addTarget(self, action: #selector(goRegisterButtonClick), for: .touchUpInside)
        
        resetPasswordButton?.setTitle("Забыли пароль?", for: .normal)
        resetPasswordButton?.addTarget(self, action: #selector(goResetPassword), for: .touchUpInside)
        rememberPasswordChecker?.addTarget(self, action: #selector(rememberPasswordChanged), for: .valueChanged)
    }
    
    @objc func goResetPassword(){
        presenter?.goToResetPassword()
    }
    
    @objc func goRegisterButtonClick(){
        presenter?.goToRegister()
    }
    
    @objc private func rememberPasswordChanged(){
        SessionConfiguration.saveAuthorization = rememberPasswordChecker?.isOn ?? false
    }
    
    @objc func loginButtonClick(){
        presenter?.login(login: loginTextField?.text, password: passwordTextField?.text)
    }
    
    func setupResetPasswordLabel(){
        let button = UIButton()
        button.backgroundColor = .clear
        button.tintColor = .clear
        button.setTitleColor(.lightGray, for: .normal)
        button.contentHorizontalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        resetPasswordButton = button
        
        guard let goRegisterButton = goRegisterButton else {
            return
        }
        
        let bottomConstraint = button.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        bottomConstraint.priority = .required
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: goRegisterButton.bottomAnchor, constant: 10),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            bottomConstraint
        ])
    }
    
    func setupGoRegisterButton(){
        let button = UIButtonEmassi()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        goRegisterButton = button
        
        guard let loginButton = loginButton else {
            return
        }
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10),
            button.heightAnchor.constraint(equalToConstant: UIButtonEmassi.defaultHeight),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    func setupLoginButton(){
        let button = UIButtonEmassi()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        loginButton = button
        
        guard let rememberPasswordChecker = rememberPasswordChecker else {
            return
        }
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: rememberPasswordChecker.bottomAnchor, constant: 10),
            button.heightAnchor.constraint(equalToConstant: UIButtonEmassi.defaultHeight),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    func setupRememberPasswordChecker(){
        let checker = UICheckBoxEmassi()
        checker.textFromImagePadding = 5
        checker.textView?.text = "Запомнить пароль"
        checker.textView?.font = .systemFont(ofSize: 16)
        checker.isOn = false
        checker.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(checker)
        rememberPasswordChecker = checker
        
        guard let passwordTextField = passwordTextField else {
            return
        }
        
        NSLayoutConstraint.activate([
            checker.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            checker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            checker.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    func setupPasswordTextField(){
        let textField = UITextFieldEmassi()
        textField.isSecureTextEntry = true
        textField.passwordRules = nil
        textField.textContentType = .password
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(textField)
        passwordTextField = textField
        
        guard let loginTextField = loginTextField else {
            return
        }

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 10),
            textField.heightAnchor.constraint(equalToConstant: UITextFieldEmassi.defaultHeight),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    func setupLoginTextField(){
        let textField = UITextFieldEmassi()
        textField.textContentType = .emailAddress
        textField.keyboardType = .emailAddress
        textField.setBorder()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(textField)
        loginTextField = textField
        
        guard let messageLabel = messageLabel else {
            return
        }

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10),
            textField.heightAnchor.constraint(equalToConstant: UITextFieldEmassi.defaultHeight),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    func setupMessageLabel(){
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .baseAppColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        messageLabel = label
        
        guard let welcomeLabel = welcomeLabel else {
            return
        }
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 6),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    func setupWelcomeLabel(){
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.textColor = .baseAppColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        welcomeLabel = label
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
}
