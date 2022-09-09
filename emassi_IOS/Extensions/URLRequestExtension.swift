//
//  URLSessionExtension.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 09.09.2022.
//

import Foundation

extension URLRequest{
    enum HTTPMethod: String{
        case get
        case post
        case delete
        case update
    }
}
