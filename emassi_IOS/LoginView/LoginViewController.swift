//
//  LoginViewController.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 02.09.2022.
//

import Foundation
import UIKit
class LoginViewController: UIViewController{
    weak var welcomeLabel: UILabel?
    weak var messageLabel: UILabel?
    weak var loginTextField: UITextField?
    weak var passwordTextField: UITextField?
    weak var rememberPasswordChecker: UISwitch?
    weak var loginButton: UIButton?
    weak var goRegisterButton: UIButton?
    weak var resetPasswordLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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
        goRegisterButton?.setTitle("Зарегистрироваться в Emassi", for: .normal)
        resetPasswordLabel?.attributedText = NSAttributedString(string: "Забыли пароль?", attributes: [.attachment:"GGGGG"])
        
    }
    func setupResetPasswordLabel(){
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        resetPasswordLabel = label
        
        guard let goRegisterButton = goRegisterButton else {
            return
        }
        
        let bottomConstraint = label.bottomAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20)
        bottomConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: goRegisterButton.bottomAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
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
            button.heightAnchor.constraint(equalToConstant: 46),
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
            button.heightAnchor.constraint(equalToConstant: 46),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    func setupRememberPasswordChecker(){
        let checker = UISwitch()
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
            checker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    func setupPasswordTextField(){
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 16)
        textField.layer.cornerRadius = 12
        textField.leftView = UIView(frame: .init(x: 0, y: 0, width: 8, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.backgroundColor = .secondarySystemBackground
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(textField)
        passwordTextField = textField
        
        guard let loginTextField = loginTextField else {
            return
        }

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 10),
            textField.heightAnchor.constraint(equalToConstant: 46),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    func setupLoginTextField(){
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 16)
        textField.layer.cornerRadius = 12
        textField.leftView = UIView(frame: .init(x: 0, y: 0, width: 8, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.backgroundColor = .secondarySystemBackground
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(textField)
        loginTextField = textField
        
        guard let messageLabel = messageLabel else {
            return
        }

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10),
            textField.heightAnchor.constraint(equalToConstant: 46),
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
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loginButton?.setCornerRadius(value: 12)
        goRegisterButton?.setCornerRadius(value: 12)
        loginTextField?.layer.cornerRadius = 12
        passwordTextField?.layer.cornerRadius = 12
    }
}
