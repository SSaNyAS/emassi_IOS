//
//  GeoPosition.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 21.09.2022.
//

import Foundation
import CoreLocation

struct GeoPosition: Codable{
    let lastUpdateDate: Date
    let coordinate: CLLocationCoordinate2D
    
    init(currentCoordinates: CLLocationCoordinate2D){
        self.lastUpdateDate = Date()
        self.coordinate = currentCoordinates
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.lastUpdateDate = try container.decode(Date.self, forKey: .lastUpdateDate)
        let lat = try container.decode(Double.self, forKey: .lat)
        let lon = try container.decode(Double.self, forKey: .lon)
        self.coordinate = .init(latitude: lat, longitude: lon)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(lastUpdateDate, forKey: .lastUpdateDate)
        try container.encode(coordinate.latitude, forKey: .lat)
        try container.encode(coordinate.longitude, forKey: .lon)
    }
    
    enum CodingKeys:String, CodingKey {
        case lastUpdateDate = "dt_last"
        case lat
        case lon
    }
}
