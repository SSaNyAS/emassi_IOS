//
//  UITextFieldExtension.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 02.09.2022.
//

import Foundation
import UIKit.UITextField

extension UITextField{
    func setTextLeftInset(value: CGFloat){
        self.leftView = UIView(frame: .init(x: 0, y: 0, width: value, height: self.frame.height))
        self.leftViewMode = .always
    }
}
