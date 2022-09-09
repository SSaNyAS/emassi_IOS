//
//  StringExtension.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 08.09.2022.
//

import Foundation
import CryptoKit
extension String{
    func isEmail() -> Bool{
        let pattern = "^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$"
        guard let regex = try? NSRegularExpression(pattern: pattern) else {return false}
        return regex.numberOfMatches(in: self, range: .init(location: 0, length: self.count)) > 0
    }
    
    func sha256() -> String{
        if let data = self.data(using: .utf8){
            let hashed = SHA256.hash(data: data)
            let hexString = hashed.compactMap({String(format: "%02x", $0)}).joined()
            return hexString
        }
        return ""
    }
}
