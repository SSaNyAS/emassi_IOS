//
//  NetworkErrorView.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 11.10.2022.
//

import Foundation
import UIKit
import Connectivity

class NetworkErrorView: UIView{
    deinit{
        print("networkChecker removed")
        NotificationCenter.default.removeObserver(self, name: .ConnectivityDidChange, object: nil)
    }
    weak var connectionStateImageView: UIImageView?
    weak var connectionTextLabel: UILabel?
    
    public var connectionImage: UIImage?{
        switch connectionInterface{
        case .wifi:
            if isConnected {
                return UIImage(systemName: "wifi")?.withTintColor(.baseAppColor, renderingMode: .alwaysOriginal)
            } else {
                return UIImage(systemName: "wifi.exclamationmark")?.withTintColor(.baseAppColor, renderingMode: .alwaysOriginal)
            }
        case .cellular:
            if isConnected{
                return UIImage(systemName: "cellularbars")?.withTintColor(.baseAppColor, renderingMode: .alwaysOriginal)
            } else {
                return UIImage(systemName: "exclamationmark.triangle.fill")?.withTintColor(.baseAppColor, renderingMode: .alwaysOriginal)
            }
        case .ethernet, .loopback, .other:
            if isConnected{
                return UIImage(systemName: "wifi")?.withTintColor(.baseAppColor, renderingMode: .alwaysOriginal)
            } else {
                return UIImage(systemName: "exclamationmark.triangle.fill")?.withTintColor(.baseAppColor, renderingMode: .alwaysOriginal)
            }
        }
        
    }
    public var disconnectedImage: UIImage? = UIImage(systemName: "wifi.slash")?.withTintColor(.baseAppColor, renderingMode: .alwaysOriginal)
    
    public var superViewFrame: CGRect?{
        didSet{
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                if let superViewFrame = self.superViewFrame{
                    let centerX = superViewFrame.midX - (self.frame.width / 2)
                    let startPosY = -self.frame.height
                    self.frame = .init(origin: .init(x: centerX, y: startPosY), size: self.frame.size)
                }
            }
        }
    }
    public var connectionInterface: ConnectivityInterface = .other
    public var isConnected: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaultSettings()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDefaultSettings()
    }
    
    func setupDefaultSettings(){
        self.isHidden = true
        self.backgroundColor = .baseAppColorBackground
        self.setCornerRadius(value: 12)
        self.layer.masksToBounds = true
        let image = disconnectedImage
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        self.connectionStateImageView = imageView
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 24,weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        self.connectionTextLabel = label
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            label.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 10),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            label.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -10),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
        ])
        self.layer.zPosition = 2000
        self.frame = .init(origin: .zero, size: .init(width: 200, height: 200))
        
        NotificationCenter.default.addObserver(self, selector: #selector(didConnectionChanged(notification:)), name: .ConnectivityDidChange, object: nil)
    }
    
    func animateAlert(isShow: Bool){
        DispatchQueue.main.async {
            if let superViewFrame = self.superViewFrame{
                let centerX = superViewFrame.midX - (self.frame.width / 2)
                let startPosY = -self.frame.height
                let endPosY = self.frame.height
                let duration = isShow ? 0.6 : 0.6
                let damping = isShow ? 0.3 : 0
                if isShow {
                    self.isHidden = false
                }
                if isShow{
                    UIView.animate(withDuration: duration,
                                   delay: 0,
                                   usingSpringWithDamping: damping,
                                   initialSpringVelocity: 0,
                                   options: [.preferredFramesPerSecond60]) {
                        self.frame = .init(origin: .init(x: centerX, y: endPosY), size: self.frame.size)
                    }
                } else {
                    UIView.animate(withDuration: duration,
                                   delay: 0.6,
                                   options: [.curveEaseInOut]) {
                        self.frame = .init(origin: .init(x: centerX, y: startPosY), size: self.frame.size)
                    } completion: { _ in
                        self.isHidden = true
                    }

                }
            }
        }
    }
    
    func updateUI(){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.connectionTextLabel?.text = self.isConnected ? "Подключение установлено" : "Отсутствует интернет соединение"
            self.connectionStateImageView?.image = self.connectionImage
            self.animateAlert(isShow: !self.isConnected)
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.superViewFrame = self.superview?.frame
        if let connectivityShared = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.connectivity{
            self.isConnected = connectivityShared.isConnected
            self.connectionInterface = connectivityShared.currentInterface
        }
    }

    @objc private func didConnectionChanged(notification: NSNotification){
        if let connectivity = notification.object as? Connectivity{
            self.isConnected = connectivity.isConnected
            self.connectionInterface = connectivity.currentInterface
            print("connectedInterface: \(self.connectionInterface)")
            updateUI()
            
        }
    }
}
