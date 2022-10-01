//
//  Address.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 15.09.2022.
//

import Foundation
import CoreLocation.CLPlacemark

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
    var countryCode: String? = nil
    
    init(place: CLPlacemark){
        self.country = place.country ?? ""
        self.state = place.administrativeArea ?? ""
        self.city = place.locality ?? ""
        self.zip = place.postalCode ?? ""
        self.line1 = place.thoroughfare ?? ""
        self.line2 = place.subThoroughfare ?? ""
        self.countryCode = place.isoCountryCode
    }
    
    init(country: String, state: String, city: String, zip: String, line1: String, line2: String){
        self.country = country
        self.state = state
        self.city = city
        self.zip = zip
        self.line1 = line1
        self.line2 = line2
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
            self.country = countryTrimmed
            self.countryCode = Locale.getCountryCode(for: countryTrimmed)
        }
        self.state = try container.decode(String.self, forKey: .state).capitalized
        self.city = try container.decode(String.self, forKey: .city).capitalized
        self.zip = try container.decode(String.self, forKey: .zip)
        self.line1 = try container.decode(String.self, forKey: .line1).capitalized
        self.line2 = try container.decode(String.self, forKey: .line2).capitalized
    }
    
    init(){
        self.country = ""
        self.state = ""
        self.city = ""
        self.zip = ""
        self.line1 = ""
        self.line2 = ""
    }
    
    var commonString: String{
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
        if !zip.isEmpty{
            string.append(zip + ", ")
        }
        if !line1.isEmpty{
            string.append(line1 + ", ")
        }
        if !line2.isEmpty{
            string.append(line2)
        }
        string = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if string.last == ","{
            string.removeLast()
        }
        return string
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let countryCode = self.countryCode {
            try container.encode(countryCode, forKey: .country)
        } else {
            let countryCodeFromName = Locale.getCountryCode(for: self.country)
            try container.encode(countryCodeFromName, forKey: .country)
        }
        try container.encode(self.state, forKey: .state)
        try container.encode(self.city, forKey: .city)
        try container.encode(self.zip, forKey: .zip)
        try container.encode(self.line1, forKey: .line1)
        try container.encode(self.line2, forKey: .line2)
    }
    enum CodingKeys: CodingKey {
        case country
        case state
        case city
        case zip
        case line1
        case line2
    }
}
