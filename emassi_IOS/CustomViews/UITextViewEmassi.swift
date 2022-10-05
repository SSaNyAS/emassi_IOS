//
//  UITextViewEmassi.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 15.09.2022.
//

import Foundation
import UIKit

class UITextViewEmassi: UITextView, UITextViewDelegate{
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupDefaultSettings()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDefaultSettings()
    }
    
    func setupDefaultSettings(){
        self.layer.masksToBounds = true
        self.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        self.delegate = self
        self.clearsOnInsertion = true
        setCornerRadius(value: 12)
        setBorder()
    }
}
