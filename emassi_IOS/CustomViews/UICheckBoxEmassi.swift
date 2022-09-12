//
//  UICheckBoxEmassi.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 03.09.2022.
//

import Foundation
import UIKit

class UICheckBoxEmassi: UISwitch, UITextViewDelegate{
    
    public weak var imageView: UIImageView?
    public weak var textView: UITextView?
    private weak var textPaddingConstraint: NSLayoutConstraint?
    private weak var imageBottomConstraint: NSLayoutConstraint?
    private weak var imageTrailingConstraint: NSLayoutConstraint?
    
    deinit{
        print("deinit CheckBoxEmassi with text \"\(textView?.text ?? "")\" and checkedValue: \(isOn)")
    }
    
    @MainActor
    public var textFromImagePadding: CGFloat = 0{
        didSet{
            self.setNeedsUpdateConstraints()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaultSettings()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDefaultSettings()
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        textView.selectedTextRange = nil
    }
    
    func setupDefaultSettings(){
        onImage = UIImage(systemName: "checkmark.circle.fill")
        offImage = UIImage(systemName: "circle")
        
        self.subviews.forEach { $0.removeFromSuperview() }
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .placeholderText
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        self.imageView = imageView
        
        let label = UITextView()
        label.textContainerInset = .zero
        label.isScrollEnabled = false
        label.isEditable = false
        label.delegate = self
        
        label.tintColor = .black
        label.textColor = .placeholderText
        
        label.textContainer.lineFragmentPadding = 0
        
        label.insetsLayoutMarginsFromSafeArea = false
        label.automaticallyAdjustsScrollIndicatorInsets = false
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        self.textView = label
        
        let textPaddingConstraint = label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: textFromImagePadding)
        textPaddingConstraint.priority = .required
        
        self.textPaddingConstraint = textPaddingConstraint
        let heightConstraint = imageView.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.priority = .required
        
        let imageToBottomConstraint = imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        imageToBottomConstraint.priority = .defaultHigh
        self.imageBottomConstraint = imageToBottomConstraint
        let imageToTrailingConstraint = imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        imageToTrailingConstraint.priority = .defaultHigh
        self.imageTrailingConstraint = imageToTrailingConstraint
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            heightConstraint,
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            textPaddingConstraint,
            label.topAnchor.constraint(equalTo: topAnchor,constant: 5),
            label.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            label.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])
        
        setupTapGesture()
        setNeedsLayout()
    }
    
    func setupTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapChecker))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        
        imageView?.isUserInteractionEnabled = true
        isUserInteractionEnabled = true
        textView?.isUserInteractionEnabled = true
        imageView?.addGestureRecognizer(tapGesture)
  
    }
    
    @objc func tapChecker(){
        setOn(!isOn, animated: true)
        DispatchQueue.main.async { [weak self] in
            self?.setNeedsLayout()
        }
    }
    override func setOn(_ on: Bool, animated: Bool) {
        super.setOn(on, animated: animated)
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else {return}
            self.imageView?.image = self.isOn ? self.onImage : self.offImage
            self.imageView?.tintColor = self.isOn ? .baseAppColor : .placeholderText
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setOn(isOn, animated: true)
        if textView?.text.isEmpty ?? true{
            imageBottomConstraint?.isActive = true
            imageTrailingConstraint?.isActive = true
        } else {
            imageBottomConstraint?.isActive = false
            imageTrailingConstraint?.isActive = false
        }
    }
    override func updateConstraints() {
        super.updateConstraints()
        self.textPaddingConstraint?.constant = textFromImagePadding
    }
    
}
