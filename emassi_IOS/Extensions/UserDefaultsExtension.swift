//
//  UserDefaultsExtension.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 06.10.2022.
//

import Foundation
extension UserDefaults{
    static let TokenKey = "Token"
    static let saveAuthorizationKey = "saveAuthorization"
    static let isDontNeedShowOnboardingKey = "isDontNeedShowOnboardingKey"
    @objc dynamic var Token: String? {
        return string(forKey: UserDefaults.TokenKey)
    }
}
