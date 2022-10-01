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

struct LocationPerformer: Codable, Hashable{
    var country: String
    var state: String
    var city: String
    
    init(from address: Address){
        self.country = address.country
        self.state = address.state
        self.city = address.city
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(country)
        hasher.combine(state)
        hasher.combine(city)
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
}
