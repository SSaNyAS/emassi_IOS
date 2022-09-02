//
//  UISeparatorWithView.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 03.09.2022.
//

import Foundation
import UIKit
class UISeparatorWithView: UIView{
    weak var line1View: UIView?
    weak var line1HeightConstraint: NSLayoutConstraint?
    weak var line1TrailingConstraint: NSLayoutConstraint?
    
    weak var betweenView: UIView?
    
    weak var line2View: UIView?
    weak var line2HeightConstraint: NSLayoutConstraint?
    weak var line2LeadingConstraint: NSLayoutConstraint?
    
    @MainActor
    public var betweenViewsSpacing: CGFloat = 40 {
        didSet{
            line1TrailingConstraint?.constant = betweenViewsSpacing / 2
            line2LeadingConstraint?.constant = betweenViewsSpacing / 2
        }
    }
    
    @MainActor
    public var lineHeight: CGFloat = 2 {
        didSet{
            line1HeightConstraint?.constant = lineHeight
            line2HeightConstraint?.constant = lineHeight
        }
    }
    
    @MainActor
    public var foregroundColor: UIColor = .separator{
        didSet{
            setForegroundColor(color: foregroundColor)
        }
    }
    
    init(view: UIView){
        super.init(frame: .zero)
        setupDefaultSettings()
        setBetweetView(centralView: view)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaultSettings()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDefaultSettings()
    }
    
    public func setBetweetView(centralView: UIView){
        betweenView?.removeFromSuperview()
        betweenView?.removeConstraints(betweenView?.constraints ?? [])
        betweenView = centralView
        centralView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(centralView)
        
        if let line1TrailingConstraint = line1TrailingConstraint {
            line1View?.removeConstraint(line1TrailingConstraint)
            self.line1TrailingConstraint = nil
        }
        
        self.line1TrailingConstraint = line1View?.trailingAnchor.constraint(equalTo: centralView.leadingAnchor, constant: -(betweenViewsSpacing / 2))
        
        if let line2LeadingConstraint = line2LeadingConstraint {
            line2View?.removeConstraint(line2LeadingConstraint)
            self.line2LeadingConstraint = nil
        }
        
        self.line2LeadingConstraint = line2View?.leadingAnchor.constraint(equalTo: centralView.trailingAnchor, constant: betweenViewsSpacing / 2)
        
        NSLayoutConstraint.activate([
            centralView.topAnchor.constraint(equalTo: topAnchor),
            centralView.bottomAnchor.constraint(equalTo: bottomAnchor),
            centralView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        line1TrailingConstraint?.isActive = true
        line2LeadingConstraint?.isActive = true
        
        setForegroundColor(color: foregroundColor)
        setNeedsUpdateConstraints()
        setNeedsLayout()
    }
    
    @MainActor
    private func setForegroundColor(color: UIColor){
        line1View?.backgroundColor = foregroundColor
        line2View?.backgroundColor = foregroundColor
    }
    
    private func setupDefaultSettings(){
        let line1 = UIView()
        line1.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(line1)
        line1View = line1
        
        line1HeightConstraint = line1.heightAnchor.constraint(equalToConstant: lineHeight)
        line1HeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            line1.centerYAnchor.constraint(equalTo: centerYAnchor),
            line1.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        let line2 = UIView()
        line2.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(line2)
        line2View = line2
        
        line2HeightConstraint = line2.heightAnchor.constraint(equalToConstant: lineHeight)
        line2HeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            line2.centerYAnchor.constraint(equalTo: centerYAnchor),
            line2.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
    }
}
