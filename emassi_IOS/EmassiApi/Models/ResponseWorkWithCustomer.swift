//
//  ResponseWorkWithCustomer.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 07.10.2022.
//

import Foundation

struct WorkWithCustomer: Codable{
    var work: WorkRequest?
    var customer: Customer?
    var myOfferToWork: Offer?
    
    var isEmptyFull: Bool {
        return work == nil && customer == nil
    }
    
    var isEmptyOne: Bool {
        return work == nil || customer == nil
    }
    
    init(){
        work = nil
        customer = nil
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let work = try? container.decodeIfPresent(WorkRequest.self, forKey: .work)
        let customer = try? container.decodeIfPresent(Customer.self, forKey: .customer)
        
        if customer == nil && work == nil{
            self.work = try container.decode(WorkRequest.self, forKey: .work)
            self.customer = try container.decode(Customer.self, forKey: .customer)
        } else {
            self.work = work
            self.customer = customer
        }
    }
    
    enum CodingKeys: CodingKey {
        case work
        case customer
    }
}
