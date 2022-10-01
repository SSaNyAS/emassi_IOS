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
    
    init(place: CLPlacemark){
        self.country = place.country ?? ""
        self.state = place.administrativeArea ?? ""
        self.city = place.locality ?? ""
        self.zip = place.postalCode ?? ""
        self.line1 = place.thoroughfare ?? ""
        self.line2 = place.subThoroughfare ?? ""
    }
    
    init(country: String, state: String, city: String, zip: String, line1: String, line2: String){
        self.country = country
        self.state = state
        self.city = city
        self.zip = zip
        self.line1 = line1
        self.line2 = line2
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
}
