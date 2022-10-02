//
//  PerformersCategory.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 03.09.2022.
//

import Foundation
struct PerformersCategory{
    let name: String
    let value: String
    let imageAddress: String
    var isOpened: Bool = false
    var subCategories: [PerformersSubCategory] = []
    
    enum CodingKeys: CodingKey{
        case name
        case value
    }
}

struct PerformersSubCategory: Codable,Equatable{
    let name: String
    let value: String
}
