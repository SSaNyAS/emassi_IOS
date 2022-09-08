//
//  RegisterViewController.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 02.09.2022.
//

import Foundation
import UIKit
import Combine

class RegisterViewController: UIViewController{
    weak var welcomeLabel: UILabel?
    weak var messageLabel: UILabel?
    weak var loginTextField: UITextField?
    weak var passwordTextField: UITextField?
    weak var passwordConfirmationTextField: UITextField?
    weak var registerButton: UIButton?
    weak var eulaAcceptChecker: UISwitch?
    weak var sendNewsChecker: UISwitch?
    weak var orSeparator: UIView?
    weak var facebookLoginButton: UIButton?
    weak var googleLoginButton: UIButton?
    weak var dontNeedRegisterButton: UIButton?
    weak var authorizationView: AuthorizationViewsData?
    var disposeBag: Set<AnyCancellable> = []
    deinit{
        disposeBag.forEach({
            $0.cancel()
        })
        disposeBag.removeAll()
    }
    
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
        setupPasswordConfirmationTextField()
        setupRegisterButton()
        setupEulaAcceptChecker()
        setupSendNewsChecker()
        setupOrSeparatorLabel()
        setupFacebookLoginButton()
        setupGoogleLoginButton()
        setupDontNeedRegisterButton()
        
        welcomeLabel?.text = "Приветствуем в Emassi!"
        messageLabel?.text = "Регистрация аккаунта"
        loginTextField?.placeholder = "Электронная почта или телефон"
        passwordTextField?.placeholder = "Пароль"
        passwordConfirmationTextField?.placeholder = "Повторите пароль"
        registerButton?.setTitle("Зарегистрироваться в Emassi", for: .normal)
        
        facebookLoginButton?.setTitle("Войти через Facebook", for: .normal)
        if let image = UIImage(named: "facebook"){
            facebookLoginButton?.setImage(image, for: .normal)
        }
        
        googleLoginButton?.setTitle("Войти через Google", for: .normal)
        if let image = UIImage(named: "google"){
            googleLoginButton?.setImage(image, for: .normal)
        }
        
        dontNeedRegisterButton?.setTitle("У меня уже есть аккаунт Emassi", for: .normal)
        dontNeedRegisterButton?.addTarget(self, action: #selector(goLoginView), for: .touchUpInside)
    }
    @objc func goLoginView(){
        if let loginVC = authorizationView?.getLoginViewController(){
            self.present(loginVC, animated: true)
        }
    }
    func setupDontNeedRegisterButton(){
        let button = UIButtonEmassi()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        dontNeedRegisterButton = button
        
        guard let googleLoginButton = googleLoginButton else {
            return
        }
        
        let bottomConstraint = button.bottomAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20)
        bottomConstraint.priority = .fittingSizeLevel
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: googleLoginButton.bottomAnchor, constant: 10),
            button.heightAnchor.constraint(equalToConstant: UIButtonEmassi.defaultHeight),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            bottomConstraint
        ])
    }
    
    func setupGoogleLoginButton(){
        let button = UIButtonEmassi()
        button.backgroundColor = .link
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // Настройка ImageView у кнопки, чтобы картинка была с левого края
        if let imageView = button.imageView{
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 30),
                imageView.topAnchor.constraint(equalTo: button.topAnchor, constant: 5),
                imageView.centerYAnchor.constraint(equalTo: button.centerYAnchor)
            ])
        }
        
        view.addSubview(button)
        googleLoginButton = button
        
        guard let facebookLoginButton = facebookLoginButton else {
            return
        }

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: facebookLoginButton.bottomAnchor, constant: 10),
            button.heightAnchor.constraint(equalToConstant: UIButtonEmassi.defaultHeight),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    func setupFacebookLoginButton(){
        let button = UIButtonEmassi()
        button.backgroundColor = .blue
        
        // Настройка ImageView у кнопки, чтобы картинка была с левого края
        if let imageView = button.imageView{
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 30),
                imageView.topAnchor.constraint(equalTo: button.topAnchor, constant: 5),
                imageView.centerYAnchor.constraint(equalTo: button.centerYAnchor)
            ])
        }
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        facebookLoginButton = button
        
        guard let orSeparator = orSeparator else {
            return
        }

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: orSeparator.bottomAnchor, constant: 10),
            button.heightAnchor.constraint(equalToConstant: UIButtonEmassi.defaultHeight),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    func setupOrSeparatorLabel(){
        let label = UILabel()
        label.textColor = .baseAppColor
        label.font = .systemFont(ofSize: 16)
        label.text = "ИЛИ"
        
        let separator = UISeparatorWithView(view: label)
        separator.foregroundColor = .baseAppColor
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(separator)
        orSeparator = separator
        
        guard let sendNewsChecker = sendNewsChecker else {
            return
        }
        
        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: sendNewsChecker.bottomAnchor, constant: 10),
            separator.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            separator.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    func setupSendNewsChecker(){
        let checker = UICheckBoxEmassi()
        let text = "Периодически всем пользователям сервиса мы присылаем письма с новостями Emassi и интересными объявлениями. Если вы хотите быть в курсе того, что происходит с Emassi, подтвердите свое согласие."
        checker.textView?.text = text
        checker.textView?.font = .systemFont(ofSize: 16)
        checker.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(checker)
        sendNewsChecker = checker
        
        guard let eulaAcceptChecker = eulaAcceptChecker else {
            return
        }
        
        NSLayoutConstraint.activate([
            checker.topAnchor.constraint(equalTo: eulaAcceptChecker.bottomAnchor, constant: 10),
            checker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            checker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    func setupEulaAcceptChecker(){
        let checker = UICheckBoxEmassi()
        let text = "Я соглашаюсь с правилами пользования сервиса, также с передачей и обработкой моих данных в Emassi. Я подтверждаю свое совершеннолетие и ответственность за размещение объявления."
        let attrString = NSMutableAttributedString(string: text)
        let range = attrString.mutableString.range(of: "правилами пользования")
        attrString.addAttribute(.link, value: "https://yandex.ru", range: range)
        attrString.addAttribute(.foregroundColor, value: UIColor.placeholderText, range: .init(location: 0, length: text.count))
        checker.textView?.attributedText = attrString
        checker.textView?.font = .systemFont(ofSize: 16)
        checker.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(checker)
        eulaAcceptChecker = checker
        
        guard let registerButton = registerButton else {
            return
        }
        
        NSLayoutConstraint.activate([
            checker.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 10),
            checker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            checker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    func setupRegisterButton(){
        let button = UIButtonEmassi()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        registerButton = button
        
        guard let passwordConfirmationTextField = passwordConfirmationTextField else {
            return
        }

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: passwordConfirmationTextField.bottomAnchor, constant: 10),
            button.heightAnchor.constraint(equalToConstant: UIButtonEmassi.defaultHeight),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    func setupPasswordConfirmationTextField(){
        let textField = UITextFieldEmassi()
        textField.isSecureTextEntry = true
        textField.passwordRules = nil
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(textField)
        passwordConfirmationTextField = textField
        
        guard let passwordTextField = passwordTextField else {
            return
        }
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            textField.heightAnchor.constraint(equalToConstant: UITextFieldEmassi.defaultHeight),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    func setupPasswordTextField(){
        let textField = UITextFieldEmassi()
        textField.isSecureTextEntry = true
        textField.passwordRules = nil
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
        label.textColor = .baseAppColor
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        messageLabel = label
        
        guard let welcomeLabel = welcomeLabel else {
            return
        }
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 10),
            label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    func setupWelcomeLabel(){
        let label = UILabel()
        label.textColor = .baseAppColor
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        welcomeLabel = label
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
}
