//
//  StringExtension.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 08.09.2022.
//

import Foundation
extension String{
    func isEmail() -> Bool{
        let pattern = "^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$"
        guard let regex = try? NSRegularExpression(pattern: pattern) else {return false}
        return regex.numberOfMatches(in: self, range: .init(location: 0, length: self.count)) > 0
    }
}
