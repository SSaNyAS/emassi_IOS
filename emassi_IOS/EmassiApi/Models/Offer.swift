//
//  Offer.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 20.09.2022.
//

import Foundation
struct Offer: Codable{
    let id: String
    let username: String
    let date: Date
    let text: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case date = "dt"
        case text
    }
}
