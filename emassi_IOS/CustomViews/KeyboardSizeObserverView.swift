//
//  KeyboardSizeObserverView.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 12.10.2022.
//

import Foundation
import UIKit

class KeyboardObserverView: UIView{
    
    private var superViewFrameStored: CGRect?
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
    weak var viewToChangeSize: UIView?
    
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
    }
    
    @objc
    private func willChangeKeyboardFrame(notification: NSNotification){
        let userInfo = notification.userInfo
        if let keyboardFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect{
            self.keyboardFrame = keyboardFrame
        }
        
        if superViewFrameStored == nil{
            superViewFrameStored = self.viewToChangeSize?.frame
        }
    }
    
    @objc
    private func willShowKeyboard(notification: NSNotification){
        setOpenedKeyBoardFrame()
        //keyBoardIsPresent = true
    }
    
    @objc
    private func willHideKeyboard(notification: NSNotification){
        if let superViewFrameStored = superViewFrameStored{
            viewToChangeSize?.frame = superViewFrameStored
        }
        //keyBoardIsPresent = false
    }
    
    private func setOpenedKeyBoardFrame(){
        if let keyboardFrame = keyboardFrame, let superViewFrameStored = superViewFrameStored{
            viewToChangeSize?.frame = .init(origin: superViewFrameStored.origin, size: .init(width: superViewFrameStored.width, height: superViewFrameStored.height - keyboardFrame.height))
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let superviewToSuperView = superview?.superview{
            viewToChangeSize = superviewToSuperView
        } else {
            viewToChangeSize = superview
        }
        superViewFrameStored = viewToChangeSize?.frame
    }
    
    private func setupDefaultSettings(){
        NotificationCenter.default.addObserver(self, selector: #selector(willChangeKeyboardFrame(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
