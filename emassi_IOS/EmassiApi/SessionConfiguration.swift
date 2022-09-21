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
    public static func removeTokenIfNeeded(){
        if !saveAuthorization{
            removeToken()
        }
    }
    public static func removeToken(){
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
}
