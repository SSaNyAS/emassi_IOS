//
//  DateStartEnd.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 15.09.2022.
//

import Foundation
protocol DateStartEndModel: Codable{
    var start: Date{get}
    var end: Date{get}
}

struct DateStartEnd: DateStartEndModel, Codable{
    let start: Date
    let end: Date
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let roundedStart = self.start.timeIntervalSince1970.rounded()
        let roundedEnd = self.end.timeIntervalSince1970.rounded()
        try container.encode(roundedStart, forKey: .start)
        try container.encode(roundedEnd, forKey: .end)
    }
}
