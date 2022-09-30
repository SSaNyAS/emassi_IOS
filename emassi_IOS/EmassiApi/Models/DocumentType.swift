//
//  DocumentType.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 28.09.2022.
//

import Foundation

enum DocumentType: RawRepresentable, Codable{
    case `private`
    case `public`
    
    typealias RawValue = String
    
    init?(rawValue: String) {
        if rawValue == "public"{
            self = .public
        }
        else{
            self = .private
        }
    }
    
    var rawValue: String{
        switch self {
        case .private:
            return "private"
        case .public:
            return "public"
        }
    }
}
