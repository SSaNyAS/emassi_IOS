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
    
    deinit{
        print("label with text: \"\(text?.prefix(10) ?? "")\" deinited")
    }
    
    public var cornerRadius: CGFloat = 12{
        didSet{
            layer.cornerRadius = cornerRadius
            setNeedsLayout()
        }
    }
    public var borderWidth: CGFloat = 2 {
        didSet{
            layer.borderWidth = borderWidth
            setNeedsLayout()
        }
    }
    public var isUseBorder: Bool = true{
        didSet{
            borderWidth =  isUseBorder ? borderWidth : 0
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
        layer.masksToBounds = true
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
        layer.borderColor = UIColor.placeholderText.cgColor
    }
    
}
