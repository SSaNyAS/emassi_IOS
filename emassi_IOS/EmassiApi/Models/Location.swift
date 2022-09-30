//
//  Location.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 15.09.2022.
//

import Foundation
protocol LocationModel:Codable{
    var country:String{get}
    var state: String{get}
    var city: String{get}
}

struct Location: LocationModel, Codable{
    let country: String
    let state: String
    let city: String
}

struct LocationPerformer: Codable{
    var country: String
    var state: String
    var city: String
    
    init(from string: String) throws {
        var string = string
        guard let countryIndex = string.firstIndex(of: ",") ?? string.firstIndex(of: " ") else {
            throw EncodingError.invalidValue(string, .init(codingPath: [], debugDescription: ""))
        }
        let country = String(string[..<countryIndex])
        string.removeSubrange(..<countryIndex)
        guard let cityIndex = string.firstIndex(of: ",") ?? string.firstIndex(of: " ") else {
            throw EncodingError.invalidValue(string, .init(codingPath: [], debugDescription: ""))
        }
        let city = String(string[..<cityIndex])
        self.state = ""
        if #available(iOS 16, *) {
            self.country = Locale.current.language.languageCode?.identifier ?? country
        } else {
            self.country = Locale.current.languageCode ?? country
        }
        self.city = string
        
    }
}
