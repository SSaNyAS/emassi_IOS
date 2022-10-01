//
//  LocaleExtension.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 02.10.2022.
//

import Foundation
extension Locale{
    static func getCountryCode(for countryName: String) -> String{
        if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryName) {
            // Country name was found
            return name
        } else {
            // Country name cannot be found
            return countryName
        }
    }
    static func getCountryName(for countryCode: String) -> String? {
        if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryCode) {
            // Country name was found
            return name
        } else {
            // Country name cannot be found
            return countryCode
        }
    }
}
