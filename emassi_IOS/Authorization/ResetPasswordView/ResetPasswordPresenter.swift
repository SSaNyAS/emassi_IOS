//
//  ResetPasswordPresenter.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 21.09.2022.
//

import Foundation
protocol ResetPasswordPresenterDelegate: NSObject{
    func resetPassword(email: String)
}

class ResetPasswordPresenter: NSObject, ResetPasswordPresenterDelegate{
    let interactor: ResetPasswordInteractorDelegate
    weak var router: RouterDelegate?
    weak var viewDelegate: ResetPasswordViewDelegate?
    
    init(interactor: ResetPasswordInteractorDelegate) {
        self.interactor = interactor
    }
    
    func resetPassword(email: String) {
        interactor.resetPassword(email: email) { [weak self] message, isSuccess in
            if isSuccess{
                self?.router?.goToViewController(from: .init(), to: .login, presentationMode: .pop)
            }
            self?.viewDelegate?.showMessage(message: message ?? "")
        }
    }
    
    
}
