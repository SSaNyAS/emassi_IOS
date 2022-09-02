//
//  UIButtonExtension.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 02.09.2022.
//

import Foundation
import UIKit
extension UIButton{
    func setCornerRadius(value: CGFloat){
        self.layer.cornerRadius = value
        self.setNeedsLayout()
    }
}
