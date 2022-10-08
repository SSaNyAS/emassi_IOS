//
//  Work.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 15.09.2022.
//

import Foundation
protocol WorkModel: Codable{
    var workId: String{get}
    var performerId: String{get}
    var type: DocumentType{get}
    var confirmed: Bool{get}
    var dateStarted: Date{get}
    var dateEnded: Date{get}
    var date: DateStartEnd{get}
    var time: Time{get}
    var price: Int{get}
    var currency: String{get}
    var comments: String{get}
    var category: Category{get}
    var performers: [Performer]{get}
}

struct Work: WorkModel,Codable{
    let workId: String
    let performerId: String
    let type: DocumentType
    let confirmed: Bool
    let dateStarted: Date
    let dateEnded: Date
    let date: DateStartEnd
    let time: Time
    let price: Int
    let currency: String
    let comments: String
    let category: Category
    let performers: [Performer]
    
    enum CodingKeys:String, CodingKey{
        case workId = "id_work"
        case performerId = "id_performer"
        case type
        case confirmed
        case dateStarted = "dt_started"
        case dateEnded = "dt_ended"
        case date
        case time
        case price
        case currency
        case comments
        case category
        case performers
    }
}

struct WorkActive: Codable{
    let workId: String
    let performerId: String
    let type: DocumentType
    let confirmed: Bool
    let dateStarted: Date
    let date: DateStartEnd
    let time: Time
    let price: Int
    let currency: String
    let comments: String
    let category: Category
    let performers: [String]
    var performersList: [PerformerForWork] = []
    
    enum CodingKeys:String, CodingKey{
        case workId = "id_work"
        case performerId = "id_performer"
        case type
        case confirmed
        case dateStarted = "dt_started"
        case date
        case time
        case price
        case currency
        case comments
        case category
        case performers
    }
}

struct AllWork: Codable{
    let id: String
    var customerId: String?
    let type: DocumentType
    let confirmed: Bool?
    let dateStarted: Date
    let dateEnded: Date?
    let category: Category
    let date: DateStartEnd
    let time: Time
    let comments: String
    let price: Int
    let currency: String
    let offer: Offer
    var customer: Customer?
    
    enum CodingKeys:String, CodingKey {
        case id
        case customerId = "id_customer"
        case type
        case confirmed
        case dateStarted = "dt_started"
        case dateEnded = "dt_ended"
        case category
        case date
        case time
        case comments
        case price
        case currency
        case offer
        case customer
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.customerId = try? container.decodeIfPresent(String.self, forKey: .customerId)
        self.type = try container.decode(DocumentType.self, forKey: .type)
        self.confirmed = try container.decodeIfPresent(Bool.self, forKey: .confirmed)
        self.dateStarted = try container.decode(Date.self, forKey: .dateStarted)
        self.dateEnded = try? container.decodeIfPresent(Date.self, forKey: .dateEnded)
        self.category = try container.decode(Category.self, forKey: .category)
        self.date = try container.decode(DateStartEnd.self, forKey: .date)
        self.time = try container.decode(Time.self, forKey: .time)
        self.comments = try container.decode(String.self, forKey: .comments)
        self.price = try container.decode(Int.self, forKey: .price)
        self.currency = try container.decode(String.self, forKey: .currency)
        self.offer = try container.decode(Offer.self, forKey: .offer)
        self.customer = try? container.decodeIfPresent(Customer.self, forKey: .customer)
    }
}

struct WorkCreate: Codable{
    var performerId: String?
    var category: Category
    var location: Location
    var distance: Int
    var date: DateStartEnd?
    var time: Time?
    var price: Int?
    var currency: String
    var phonenumber: String?
    var address: Address
    var geopos: GeoPosition
    var comments: String
    var details: String?
    
    enum CodingKeys:String, CodingKey {
        case performerId = "id_performer"
        case category
        case location
        case distance
        case date
        case time
        case price
        case currency
        case phonenumber
        case address
        case geopos
        case comments
        case details
    }
}

struct WorkRequest: Codable{
    let id: String
    let startDate: Date
    let category: Category
    let date: DateStartEnd
    let time: Time
    let address: Address?
    let geopos: GeoPosition?
    let phoneNumber: String?
    let price: Int
    let currency: String
    let comments: String
    let photos: [String]
    let offers: [Offer]
    
    enum CodingKeys:String, CodingKey {
        case id
        case startDate = "dt_started"
        case category
        case date
        case time
        case address
        case geopos
        case phoneNumber = "phonenumber"
        case price
        case currency
        case comments
        case photos
        case offers
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.startDate = try container.decode(Date.self, forKey: .startDate)
        self.category = try container.decode(Category.self, forKey: .category)
        self.date = try container.decode(DateStartEnd.self, forKey: .date)
        self.time = try container.decode(Time.self, forKey: .time)
        self.address = try? container.decodeIfPresent(Address.self, forKey: .address)
        self.geopos = try? container.decodeIfPresent(GeoPosition.self, forKey: .geopos)
        self.phoneNumber = try? container.decodeIfPresent(String.self, forKey: .phoneNumber)
        self.price = try container.decode(Int.self, forKey: .price)
        self.currency = try container.decode(String.self, forKey: .currency)
        self.comments = try container.decode(String.self, forKey: .comments)
        self.photos = try container.decode([String].self, forKey: .photos)
        self.offers = try container.decode([Offer].self, forKey: .offers)
    }
}
