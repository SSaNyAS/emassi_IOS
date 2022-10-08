//
//  DateExtension.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 04.10.2022.
//

import Foundation
extension Date{
    func formatted(formatString: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatString
        return dateFormatter.string(from: self)
    }
    
    func formattedAsDateTime() -> String{
        self.formatted(formatString: "dd.MM.yyyy HH:mm")
    }
}
