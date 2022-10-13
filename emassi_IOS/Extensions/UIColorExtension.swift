//
//  UIColorExtension.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 01.09.2022.
//

import Foundation
import UIKit.UIColor

extension UIColor {
    static var baseAppColor: UIColor{
        if let color = UIColor(named: "baseAppColor"){
            return color
        }
        return UIColor(red: 87/255, green: 144/255, blue: 155/255, alpha: 1)
    }
    static var baseAppColorBackground: UIColor{
        if let color = UIColor(named: "baseAppBackgroundToItems"){
            return color
        }
        if UITraitCollection.current.userInterfaceStyle == .dark{
            return .placeholderText
        } else {
            return UIColor(red: 230/255, green: 243/255, blue: 245/255, alpha: 1)
        }
    }
    
    static var invertedSystemBackground: UIColor{
        if let color = UIColor(named: "invertedSystemBackground"){
            return color
        }
        if UITraitCollection.current.userInterfaceStyle == .dark{
            return .white
        } else {
            return .black
        }
    }
}
