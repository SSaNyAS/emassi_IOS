//
//  UITextFieldEmassi.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 02.09.2022.
//

import Foundation
import UIKit
class UITextFieldEmassi: UITextField, UITextFieldDelegate{
    static let defaultHeight: CGFloat = 40
    private var inputViewControllerStored: UIInputViewController?
    
    override var inputViewController: UIInputViewController?{
        get{
            inputViewControllerStored
        }
        set{
            inputViewControllerStored = newValue
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return isTextEditable
    }
    
    public var isTextEditable: Bool = true{
        didSet{
            DispatchQueue.main.async {
                self.text = ""
            }
        }
    }
    
//    public var isUseCustomInputView: Bool = false
    
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
        minimumFontSize = 8
        adjustsFontSizeToFitWidth = true
        backgroundColor = .secondarySystemBackground
        setTextLeftInset(value: 8)
        setCornerRadius(value: 12)
        delegate = self
    }
}
