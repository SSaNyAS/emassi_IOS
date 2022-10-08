//
//  SendFeedbackInteractor.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 09.10.2022.
//

import Foundation
protocol SendFeedbackInteractorDelegate: AnyObject{
    func setWorkId(workId: String)
    func setRating(rating: Float)
    func setFeedbackText(text: String)
    func sendCustomerFeedback(completion: @escaping (EmassiApiResponse?, Error?) -> Void)
}

class SendFeedbackInteractor: SendFeedbackInteractorDelegate{
    
    var emassiApi: EmassiApi
    var workId: String = ""
    var rating: Float = 0.0
    var feedbackText: String = ""
    
    init(emassiApi: EmassiApi) {
        self.emassiApi = emassiApi
    }
    
    func sendCustomerFeedback(completion: @escaping (EmassiApiResponse?, Error?) -> Void){
        emassiApi.sendCustomerFeedback(workId: workId, rating: rating, text: feedbackText, completion: completion)
    }
    
    func setWorkId(workId: String) {
        self.workId = workId
    }
    
    func setRating(rating: Float) {
        self.rating = rating
    }
    
    func setFeedbackText(text: String) {
        self.feedbackText = text
    }
}
