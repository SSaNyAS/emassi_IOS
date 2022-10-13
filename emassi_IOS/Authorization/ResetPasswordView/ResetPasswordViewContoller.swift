//
//  ResetPasswordViewContoller.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 21.09.2022.
//

import Foundation
import UIKit
protocol ResetPasswordViewDelegate: NSObjectProtocol{
    func showMessage(message: String)
}

class ResetPasswordViewController: UIViewController, ResetPasswordViewDelegate{
    weak var emailLabel: UILabel?
    weak var emailTextField: UITextField?
    weak var recoverButton: UIButton?
    var presenter: ResetPasswordPresenterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        emailLabel?.text = "Укажите email адрес для получения дальнейшей инструкции"
        recoverButton?.setTitle("Восстановить пароль", for: .normal)
        recoverButton?.addTarget(self, action: #selector(recoverButtonClick), for: .touchUpInside)
    }
    
    @objc private func recoverButtonClick(){
        presenter?.resetPassword(email: emailTextField?.text ?? "")
    }
    
    private func setupViews(){
        createEmailLabel()
        createEmailTextField()
        createRecoverButton()
        
        guard let emailLabel = emailLabel,
              let emailTextField = emailTextField,
              let recoverButton = recoverButton else {
            return
        }
        
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            emailLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            emailLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            
            emailTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 2),
            emailTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            emailTextField.heightAnchor.constraint(equalToConstant: UITextFieldEmassi.defaultHeight),
            
            recoverButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            recoverButton.topAnchor.constraint(greaterThanOrEqualTo: emailTextField.bottomAnchor, constant: 10),
            recoverButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            recoverButton.heightAnchor.constraint(equalToConstant: UIButtonEmassi.defaultHeight),
            recoverButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
    }
    
    private func createRecoverButton(){
        let button = UIButtonEmassi()
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        recoverButton = button
    }
    
    private func createEmailTextField(){
        let textField = UITextFieldEmassi()
        textField.textContentType = .emailAddress
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        emailTextField = textField
    }
    
    private func createEmailLabel(){
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .placeholderText
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        emailLabel = label
    }
}
