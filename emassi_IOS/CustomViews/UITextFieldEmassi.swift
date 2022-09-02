//
//  UITextFieldEmassi.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 02.09.2022.
//

import Foundation
import UIKit
class UITextFieldEmassi: UITextField{
    static let defaultHeight: CGFloat = 46
    
    init(){
        super.init(frame: .zero)
        setupDefaultSettings()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaultSettings()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDefaultSettings()
    }
    
    
    func setupDefaultSettings(){
        font = .systemFont(ofSize: 16)
        backgroundColor = .secondarySystemBackground
        setTextLeftInset(value: 8)
        setCornerRadius(value: 12)
    }
}
