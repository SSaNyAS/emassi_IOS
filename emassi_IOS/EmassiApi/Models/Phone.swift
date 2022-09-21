//
//  Phone.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 15.09.2022.
//

import Foundation
protocol PhoneModel: Codable{
    var number: String{get}
    var confirmed: Bool{get}
}

struct Phone: Codable, PhoneModel{
    let number: String
    let confirmed: Bool
}
