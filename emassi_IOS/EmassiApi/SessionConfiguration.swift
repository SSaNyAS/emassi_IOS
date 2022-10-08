//
//  SessionConfiguration.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 21.09.2022.
//

import Foundation
public class SessionConfiguration{
    
    static let lastWorksRequestDateKey = "lastWorksRequestDate"
    
    static var tokenObserver: NSKeyValueObservation?
    
    public static var isDontNeedShowOnboarding: Bool{
        get{
            return UserDefaults.standard.bool(forKey: UserDefaults.isDontNeedShowOnboardingKey)
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: UserDefaults.isDontNeedShowOnboardingKey)
        }
    }
    
    public static var saveAuthorization: Bool{
        get{
            return UserDefaults.standard.bool(forKey: UserDefaults.saveAuthorizationKey)
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: UserDefaults.saveAuthorizationKey)
        }
    }
    
    public static var Token: String?{
        get{
            UserDefaults.standard.string(forKey: UserDefaults.TokenKey)
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: UserDefaults.TokenKey)
            if newValue?.isEmpty == false{
                tokenObserver =  UserDefaults.standard.observe(\.Token, options: [.initial, .new], changeHandler: {[weak tokenObserver] (defaults, change) in
                    if (change.newValue??.isEmpty ?? true) == true{
                        Logout()
                        tokenObserver?.invalidate()
                    }
                })
            }
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
            UserDefaults.standard.removeObject(forKey: UserDefaults.TokenKey)
            UserDefaults.standard.removeObject(forKey: UserDefaults.saveAuthorizationKey)
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
