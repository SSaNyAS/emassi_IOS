//
//  WorkStatus.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 10.10.2022.
//

import Foundation
enum WorkStatus: String, Codable{
    case accept = "accept"
    case cancel = "cancel"
    case unknown = ""
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self, forKey: .action)
    }
    
    init(from decoder: Decoder) throws {
        let containter = try decoder.container(keyedBy: CodingKeys.self)
        let action = try containter.decode(String.self, forKey: .action)
        self = .init(rawValue: action) ?? .unknown
    }
    
    enum CodingKeys: CodingKey {
        case action
    }
}
