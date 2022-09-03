//
//  UIButtonExtension.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 02.09.2022.
//

import Foundation
import UIKit.UIView

extension UIView{
    func setCornerRadius(value: CGFloat){
        self.layer.cornerRadius = value
        self.setNeedsLayout()
    }
    func setBorder(){
        self.layer.borderColor = UIColor.placeholderText.cgColor
        self.layer.borderWidth = 2
    }
}
