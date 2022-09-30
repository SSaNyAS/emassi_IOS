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
    let type: DocumentType
    
    enum CodingKeys: String, CodingKey{
        case name
        case id = "id_photo"
        case type
    }
    
    init(id: String,name: String, type: DocumentType = .private) {
        self.id = id
        self.name = name
        self.type = type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.id = try container.decode(String.self, forKey: .id)
        self.type = (try? container.decodeIfPresent(DocumentType.self, forKey: .type)) ?? .private
    }
}
