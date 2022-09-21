//
//  Address.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 15.09.2022.
//

import Foundation
protocol AddressModel: Codable{
    var country: String{get}
    var state: String{get}
    var city: String{get}
    var zip: String{get}
    var line1: String{get}
    var line2: String{get}
}

struct Address: AddressModel, Codable{
    let country: String
    let state: String
    let city: String
    let zip: String
    let line1: String
    let line2: String
}
