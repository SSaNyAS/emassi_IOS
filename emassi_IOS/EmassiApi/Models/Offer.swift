//
//  Offer.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 20.09.2022.
//

import Foundation
struct Offer: Codable{
    let id: String?
    let username: String?
    let date: Date
    let text: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case date = "dt"
        case text
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try? container.decodeIfPresent(String.self, forKey: .id)
        self.username = try? container.decodeIfPresent(String.self, forKey: .username)
        self.date = try container.decode(Date.self, forKey: .date)
        self.text = try container.decode(String.self, forKey: .text)
    }
    
    public var isEmpty: Bool{
        return text.isEmpty && date.timeIntervalSince1970 == 0
    }
}
