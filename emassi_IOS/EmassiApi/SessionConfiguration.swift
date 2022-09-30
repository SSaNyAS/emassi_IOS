//
//  SessionConfiguration.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 21.09.2022.
//

import Foundation
public class SessionConfiguration{
    static let saveAuthorizationKey = "saveAuthorization"
    static let tokenKey = "Token"
    static let lastWorksRequestDateKey = "lastWorksRequestDate"
    static let isDontNeedShowOnboardingKey = "isDontNeedShowOnboardingKey"
    
    public static var isDontNeedShowOnboarding: Bool{
        get{
            return UserDefaults.standard.bool(forKey: isDontNeedShowOnboardingKey)
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: isDontNeedShowOnboardingKey)
        }
    }
    
    public static var saveAuthorization: Bool{
        get{
            return UserDefaults.standard.bool(forKey: saveAuthorizationKey)
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: saveAuthorizationKey)
        }
    }
    
    public static var Token: String?{
        get{
            UserDefaults.standard.string(forKey: tokenKey)
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: tokenKey)
        }
    }
    
    public static var lastWorksRequestDate: Date?{
        get{
            return UserDefaults.standard.value(forKey: lastWorksRequestDateKey) as? Date
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: lastWorksRequestDateKey)
        }
    }
    
    public static func removeTokenIfNeeded(){
        if !saveAuthorization{
            removeToken()
        }
    }
    public static func removeToken(completion: ((Bool)-> Void)? = nil){
        DispatchQueue.main.async {
            UserDefaults.standard.removeObject(forKey: tokenKey)
            UserDefaults.standard.removeObject(forKey: saveAuthorizationKey)
            let result = UserDefaults.standard.synchronize()
            completion?(result)
        }
    }
    
    public static func Logout(completion: ((Bool)-> Void)? = nil){
        removeToken{isSuccess in
            NotificationCenter.default.post(name: .logoutNotification, object: isSuccess)
            completion?(isSuccess)
        }
    }
}
