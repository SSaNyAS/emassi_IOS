//
//  SendFeedbackPresenter.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 09.10.2022.
//

import Foundation
protocol SendFeedbackPresenterDelegate: AnyObject{
    func sendFeedback()
    func setFeedbackText(text: String?)
    func setFeedbackRating(rating: Float)
}

class SendFeedbackPresenter: SendFeedbackPresenterDelegate{
    var interactor: SendFeedbackInteractorDelegate
    var profileMode: ProfileMode
    weak var router: RouterDelegate?
    weak var viewDelegate: SendFeedbackViewDelegate?
    
    var workId: String? {
        didSet{
            self.interactor.setWorkId(workId: workId ?? "")
        }
    }
    
    init(interactor: SendFeedbackInteractorDelegate, profileMode: ProfileMode) {
        self.interactor = interactor
        self.profileMode = profileMode
    }
    
    func sendFeedback(){
        if profileMode == .customer {
            interactor.sendCustomerFeedback { [weak self] apiResponse, error in
                if apiResponse?.isErrored == false{
                    self?.viewDelegate?.dismiss(animated: true)
                }
                self?.viewDelegate?.showMessage(message: error?.localizedDescription ?? apiResponse?.message ?? "", title: "")
            }
        } else {
            interactor.sendPerformerFeedback { [weak self] apiResponse, error in
                if apiResponse?.isErrored == false{
                    self?.viewDelegate?.dismiss(animated: true)
                }
                self?.viewDelegate?.showMessage(message: error?.localizedDescription ?? apiResponse?.message ?? "", title: "")
            }
        }
    }
    
    func setFeedbackText(text: String?) {
        guard let text = text, text.isEmpty == false else {
            viewDelegate?.showMessage(message: "Укажите текст отзыва", title: "")
            return
        }
        interactor.setFeedbackText(text: text)
    }
    
    func setFeedbackRating(rating: Float) {
        interactor.setRating(rating: rating)
    }
}
