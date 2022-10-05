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

struct Location: Codable, Hashable{
    var ignore: Bool? = nil
    var country: String
    var state: String
    var city: String
    var countryCode: String?
    
    init(from address: Address){
        self.country = address.country
        self.state = address.state
        self.city = address.city
        self.countryCode = address.countryCode
    }
    
    init(){
        self.country = ""
        self.state = ""
        self.city = ""
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(country)
        hasher.combine(state)
        hasher.combine(city)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let country = try? container.decode(String.self, forKey: .country)
        let countryTrimmed = country?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let isISOFormat = Locale.isoLanguageCodes.contains(where: {
            $0 == countryTrimmed
        })
        if isISOFormat{
            self.countryCode = countryTrimmed
            self.country = Locale.getCountryName(for: countryTrimmed)?.capitalized ?? countryTrimmed.capitalized
        } else {
            self.country = countryTrimmed.capitalized
            self.countryCode = Locale.getCountryCode(for: countryTrimmed)
        }
        self.ignore = try? container.decodeIfPresent(Bool.self, forKey: .ignore)
        self.state = try container.decode(String.self, forKey: .state).capitalized
        self.city = try container.decode(String.self, forKey: .city).capitalized
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encodeIfPresent(self.ignore, forKey: .ignore)
        if let countryCode = self.countryCode {
            try container.encode(countryCode, forKey: .country)
        } else {
            let countryCodeFromName = Locale.getCountryCode(for: self.country)
            try container.encode(countryCodeFromName, forKey: .country)
        }
        try container.encode(self.state, forKey: .state)
        try container.encode(self.city, forKey: .city)
    }
    
    var common: String {
        var string = ""
        if !country.isEmpty{
            
            string.append(country + ", ")
        }
        if !state.isEmpty{
            string.append(state + ", ")
        }
        if !city.isEmpty{
            string.append(city + ", ")
        }
        string = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if string.last == ","{
            string.removeLast()
        }
        return string
    }

    enum CodingKeys: CodingKey {
        case ignore
        case country
        case state
        case city
    }
}
