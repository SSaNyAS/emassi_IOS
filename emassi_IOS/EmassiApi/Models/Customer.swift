//
//  Customer.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 15.09.2022.
//

import Foundation
protocol CustomerModel: Codable{
    var username: Username{get}
    var phone: Phone{get}
    var address: Address{get}
    var rating: Float{get}
    var rating5: Float{get}
    var requests: Int{get}
}

struct Customer: Codable{
    let photo: String
    let username: Username
    let phone: Phone?
    let address: Address?
    let rating: Float
    let rating5: Float
    let requests: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.photo = try container.decode(String.self, forKey: .photo)
        self.username = try container.decode(Username.self, forKey: .username)
        self.phone = try? container.decodeIfPresent(Phone.self, forKey: .phone)
        self.address = try? container.decodeIfPresent(Address.self, forKey: .address)
        self.rating = try container.decode(Float.self, forKey: .rating)
        self.rating5 = try container.decode(Float.self, forKey: .rating5)
        self.requests = try container.decode(Int.self, forKey: .requests)
    }
}

struct CustomerProfile: Codable{
    var email: Email
    var username: Username
    var phone: Phone
    var address: Address
    var rating: Float
    var rating5: Float
    var requests: Int
}
