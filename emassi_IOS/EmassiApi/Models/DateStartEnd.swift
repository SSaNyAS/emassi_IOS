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
}
