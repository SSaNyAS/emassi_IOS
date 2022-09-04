//
//  UILabelBordered.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 04.09.2022.
//

import Foundation
import UIKit.UILabel

class UILabelBordered: UILabel{
    public var textInsets: UIEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10) {
        didSet{
            invalidateIntrinsicContentSize()
        }
    }
    init(){
        super.init(frame: .zero)
        setupDefaultSetting()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaultSetting()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDefaultSetting()
    }
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top, left: -textInsets.left, bottom: -textInsets.bottom, right: -textInsets.right)
        return textRect.inset(by: invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
    
    func setupDefaultSetting(){
        font = .systemFont(ofSize: 16)
        setCornerRadius(value: 12)
        setBorder()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
