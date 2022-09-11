//
//  UIButtonEmassi.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 02.09.2022.
//

import Foundation
import UIKit
class UIButtonEmassi: UIButton{
    static let defaultHeight: CGFloat = 46
    
    deinit{
        print("button with title \"\(title(for: .normal) ?? "")\" deinited ")
    }
    
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
        backgroundColor = .baseAppColor
        titleLabel?.font = .systemFont(ofSize: 16)
        titleLabel?.textColor = .white
        setCornerRadius(value: 12)
    }
    override func didMoveToSuperview() {
        if superview != nil {
            addTarget(self, action: #selector(pressAnim), for: .touchDown)
        }
        super.didMoveToSuperview()
    }

    override func removeFromSuperview() {
        removeTarget(self, action: #selector(pressAnim), for: .touchDown)
        super.removeFromSuperview()
    }
    
    @MainActor
    @objc private func pressAnim(){
        UIView.animate(withDuration: 0.07, delay: 0, options: .curveEaseIn) { [weak self] in
                self?.transform = .init(scaleX: 0.97, y: 0.97)
        } completion: { [weak self]  isFinished in
            if (isFinished){
                UIView.animate(withDuration: 0.1) { [weak self] in
                    self?.transform = .identity
                }
            }
        }
    }
}
