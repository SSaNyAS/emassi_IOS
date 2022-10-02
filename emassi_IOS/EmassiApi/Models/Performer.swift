//
//  Performer.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 15.09.2022.
//

import Foundation

protocol PerformerModel: Codable{
    var id: String{get}
    var username: Username{get}
    var phone: Phone{get}
    var photos: [Photo]{get}
    var comments: String{get}
    var rating: Float{get}
    var rating5: Float{get}
    var works: Int{get}
    var verified: Bool{get}
    var reviews: [Review]{get}
}

struct PerformerForList: Codable{
    let id: String
    let username: Username
    let comments: String
    let rating: Float
    let rating5: Float
    let works: Int
    let reviews: Int
    let verified: Bool
    let location: Location
    let promote: Bool
}

struct Performer: Codable, PerformerModel{
    let id: String
    let username: Username
    let phone: Phone
    let photos: [Photo]
    let comments: String
    let rating: Float
    let rating5: Float
    let works: Int
    let verified: Bool
    let reviews: [Review]
    
    enum CodingKeys: String, CodingKey{
        case id
        case username
        case phone
        case photos
        case comments
        case rating
        case rating5
        case works
        case verified
        case reviews
    }
    
}

protocol PerformerProfileModel: Codable{
    var email: Email{get}
    var username: Username{get}
    var phone: Phone{get}
    var address: Address{get}
    var rating: Float{get}
    var rating5: Float{get}
    var works: Int{get}
    var comments: String{get}
    var location: [Location]{get}
    var category: [String]{get}
    var photos: [Photo]{get}
}

struct PerformerProfile: PerformerProfileModel, Codable{
    let email: Email
    let username: Username
    let phone: Phone
    let address: Address
    let rating: Float
    let rating5: Float
    let works: Int
    let comments: String
    let location: [Location]
    let category: [String]
    let photos: [Photo]
}

protocol PerformerProfileCreateUpdateModel: Codable{
    var username: Username{get set}
    var phoneNumber: String{get set}
    var location: [Location]{get set}
    var category: [Category]{get set}
    var comments: String{get set}
}

struct PerformerProfileCreateUpdate: PerformerProfileCreateUpdateModel,Codable{
    var username: Username
    var phoneNumber: String
    var location: [Location]
    var category: [Category]
    var comments: String
    
    enum CodingKeys: String, CodingKey{
        case username
        case phoneNumber
        case location
        case category
        case comments
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(username, forKey: .username)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(location, forKey: .location)
        try container.encode(category, forKey: .category)
        try container.encode(comments, forKey: .comments)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.username = try container.decode(Username.self, forKey: .username)
        self.phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        self.location = try container.decode([Location].self, forKey: .location)
        self.category = try container.decode([Category].self, forKey: .category)
        self.comments = try container.decode(String.self, forKey: .comments)
    }
}

struct PerformerInfo: Codable{
    let id: String
    let verified: Bool
    let username: Username
    let location: Location
    let phone: Phone
    let photos: [Photo]
    let comments: String
    let rating: Float
    let rating5: Float
    let works: Int
    let reviews: [Review]
}

struct PerformerForWork: Codable{
    let id: String
    let username: Username
    let rating: Float
    let rating5: Float
    let works: Int
    let reviews: Int
    let verified: Bool
    let offer: Offer
}

struct RequestPerformerProfile: Codable{
    var username: Username
    var phonenumber: String
    var address: Address
    var location: [Location]
    var category: [String]
    var comments: String
}
