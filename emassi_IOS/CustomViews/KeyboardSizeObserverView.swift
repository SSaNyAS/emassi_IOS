//
//  KeyboardSizeObserverView.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 12.10.2022.
//

import Foundation
import UIKit

class KeyboardObserverView: UIView{
    static let bottomIdentifire = "bottomToView"
    private var superViewFrameStored: CGRect?
    private var superViewBottomConstantStoredValue: CGFloat?
    private var bottomConstraint: NSLayoutConstraint?
    
    public var keyboardFrame: CGRect?{
        didSet{
            if keyBoardIsPresent {
                DispatchQueue.main.async{
                    self.setOpenedKeyBoardFrame()
                }
            }
        }
    }
    public var keyBoardIsPresent: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaultSettings()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDefaultSettings()
    }
    deinit{
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        print("keyboardObserver removed")
    }
    
    @objc
    private func willChangeKeyboardFrame(notification: NSNotification){
        let userInfo = notification.userInfo
        if let keyboardFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect{
            self.keyboardFrame = keyboardFrame
        }
    }
    
    @objc
    private func willShowKeyboard(notification: NSNotification){
        setOpenedKeyBoardFrame()
    }
    
    @objc
    private func willHideKeyboard(notification: NSNotification){
        if let superViewBottomConstantStoredValue = superViewBottomConstantStoredValue{
            UIView.animate(withDuration: 0.6) {
                self.bottomConstraint?.constant = superViewBottomConstantStoredValue
            }
            return
        }
        if let superViewFrameStored = superViewFrameStored{
            superview?.frame = superViewFrameStored
        }
    }
    
    private func setOpenedKeyBoardFrame(){
        if let bottomConstraint = bottomConstraint{
            UIView.animate(withDuration: 0.6) {
                bottomConstraint.constant = bottomConstraint.constant - (self.keyboardFrame?.height ?? 0) - 50
            }
            return
        }
        if let keyboardFrame = keyboardFrame, let superViewFrameStored = superViewFrameStored{
            superview?.frame = .init(origin: superViewFrameStored.origin, size: .init(width: superViewFrameStored.width, height: superViewFrameStored.height - keyboardFrame.height))
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let verticalConstraints = superview?.constraintsAffectingLayout(for: .vertical){
            if let lastBottom = verticalConstraints.last(where: { $0.firstAttribute == .bottom && $0.secondAttribute == .bottom }){
                bottomConstraint = lastBottom
                self.superViewBottomConstantStoredValue = lastBottom.constant
                return
            }
        }
        superViewFrameStored = superview?.frame
    }
    
    private func setupDefaultSettings(){
        NotificationCenter.default.addObserver(self, selector: #selector(willChangeKeyboardFrame(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
