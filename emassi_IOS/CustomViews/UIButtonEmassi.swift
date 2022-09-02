//
//  UIButtonEmassi.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 02.09.2022.
//

import Foundation
import UIKit
class UIButtonEmassi: UIButton{
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
    
    private func setupDefaultSettings(){
        self.backgroundColor = .baseAppColor
        self.titleLabel?.font = .systemFont(ofSize: 16)
        self.titleLabel?.textColor = .white
        self.setCornerRadius(value: 12)
    }
}
