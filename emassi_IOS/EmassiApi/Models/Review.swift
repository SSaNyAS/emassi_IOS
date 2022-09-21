//
//  Review.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 15.09.2022.
//

import Foundation

protocol ReviewModel: Codable{
    var workId: String{get}
    var customerId: String{get}
    var date: Date{get}
    var rating: Int{get}
    var text: String{get}
}

struct Review: Codable, ReviewModel{
    let workId: String
    let customerId: String
    let date: Date
    let rating: Int
    let text: String
    
    enum CodingKeys: String, CodingKey{
        case workId = "id_work"
        case customerId = "id_customer"
        case date = "dt"
        case rating
        case text
    }
}
