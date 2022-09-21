//
//  Category.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 15.09.2022.
//

import Foundation
protocol CategoryModel: Codable{
    var level1: String{get}
    var level2: String{get}
}

struct Category: CategoryModel, Codable{
    let level1: String
    let level2: String
}
