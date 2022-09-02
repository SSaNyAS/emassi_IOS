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
        addTarget(self, action: #selector(pressAnim), for: .touchDown)
        self.setCornerRadius(value: 12)
    }
    
    @MainActor
    @objc private func pressAnim(){
        UIView.animate(withDuration: 0.07, delay: 0, options: .curveEaseIn) { [weak self] in
                self?.transform = .init(scaleX: 0.97, y: 0.97)
        } completion: { isFinished in
            if (isFinished){
                UIView.animate(withDuration: 0.1) { [weak self] in
                    self?.transform = .identity
                }
            }
        }
    }
}
