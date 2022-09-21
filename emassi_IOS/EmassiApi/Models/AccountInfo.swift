//
//  AccountInfo.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 20.09.2022.
//

import Foundation
protocol AccountInfoModel: Codable{
    var username: Username{get}
    var email: Email{get}
    var phone: Phone{get}
    var customer: UserStatus{get}
    var performer: UserStatus{get}
    var address: Address{get}
    var balance: UInt64{get}
}

struct AccountInfo: AccountInfoModel, Codable{
    let username: Username
    let email: Email
    let phone: Phone
    let customer: UserStatus
    let performer: UserStatus
    let address: Address
    let balance: UInt64
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.username = try container.decode(Username.self, forKey: .username)
        self.email = try container.decode(Email.self, forKey: .email)
        self.phone = try container.decode(Phone.self, forKey: .phone)
        self.customer = try container.decode(UserStatus.self, forKey: .customer)
        self.performer = try container.decode(UserStatus.self, forKey: .performer)
        self.address = try container.decode(Address.self, forKey: .address)
        self.balance = try container.decode(UInt64.self, forKey: .balance)
    }
}


struct Email: Codable{
    let address: String
    let confirmed: Bool
}

struct UserStatus: Codable{
    let active: Bool
    let rating: Float
}
