//
//  PerformersMainCategory.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 03.09.2022.
//

struct PerformersMainCategory: PerformersCategory{
    static func == (lhs: PerformersMainCategory, rhs: PerformersMainCategory) -> Bool {
        lhs.value == rhs.value
    }
    
    let name: String
    let value: String
    
    let imageAddress: String
    var isOpened: Bool
    var subCategories: [PerformersSubCategory] = []
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
    enum CodingKeys: CodingKey{
        case name
        case value
    }
    
    init(name: String, value: String,imageAddress: String = "" , isOpened: Bool = false, subCategories: [PerformersSubCategory]) {
        self.name = name
        self.value = value
        self.imageAddress = imageAddress
        self.isOpened = isOpened
        self.subCategories = subCategories
    }
}

protocol PerformersCategory: Equatable, Hashable{
    var value: String{get}
    var name: String{get}
}

struct PerformersSubCategory: PerformersCategory{
    
    static func == (lhs: PerformersSubCategory, rhs: PerformersSubCategory) -> Bool {
        lhs.value == rhs.value
    }
    
    let name: String
    let value: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}
