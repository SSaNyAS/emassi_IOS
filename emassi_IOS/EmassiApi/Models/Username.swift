//
//  Username.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 15.09.2022.
//

import Foundation
protocol UsernameModel: Codable{
    var firstname: String {get}
    var lastname: String {get}
    var common: String {get}
}

struct Username: Codable, UsernameModel{
    let common: String
    let firstname: String
    let lastname: String
}
