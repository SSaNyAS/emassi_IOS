//
//  Photo.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 15.09.2022.
//

import Foundation

protocol PhotoModel: Codable{
    var name: String{get}
    var id: String{get}
}

struct Photo: Codable, PhotoModel{
    let name: String
    let id: String
    let type: String?
    
    enum CodingKeys: String, CodingKey{
        case name
        case id = "id_photo"
        case type
    }
}
