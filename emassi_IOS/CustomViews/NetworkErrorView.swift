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
    weak var connectionStateImageView: UIImageView?
    weak var connectionTextLabel: UILabel?
    
    public var connectedImage: UIImage? = UIImage(systemName: "wifi")?.withTintColor(.baseAppColor, renderingMode: .alwaysOriginal)
    public var disconnectedImage: UIImage? = UIImage(systemName: "wifi.slash")?.withTintColor(.baseAppColor, renderingMode: .alwaysOriginal)
    
    public var superViewFrame: CGRect?{
        didSet{
            DispatchQueue.main.async {
                if let superViewFrame = self.superViewFrame{
                    let centerX = superViewFrame.midX - (self.frame.width / 2)
                    let startPosY = -self.frame.height
                    self.frame = .init(origin: .init(x: centerX, y: startPosY), size: self.frame.size)
                }
            }
        }
    }
    
    public var isConnected: Bool = true{
        didSet{
            DispatchQueue.main.async {
                self.connectionTextLabel?.text = self.isConnected ? "Подключение установлено" : "Отсутствует интернет соединение"
                self.connectionStateImageView?.image = self.connectedImage
                self.animateAlert(isShow: !self.isConnected)
            }
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
    
    func setupDefaultSettings(){
        //self.backgroundColor = .white.withAlphaComponent(0.3)
        self.setCornerRadius(value: 12)
        self.layer.masksToBounds = true
        let image = disconnectedImage
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            label.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            label.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            label.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
        ])
        self.layer.zPosition = .infinity
        self.frame = .init(origin: .zero, size: .init(width: 200, height: 200))
        
        NotificationCenter.default.addObserver(self, selector: #selector(didConnectionChanged(notification:)), name: .ConnectivityDidChange, object: nil)
    }
    
    func animateAlert(isShow: Bool){
        DispatchQueue.main.async {
            if let superViewFrame = self.superViewFrame{
                let centerX = superViewFrame.midX - (self.frame.width / 2)
                let startPosY = -self.frame.height
                let endPosY = self.frame.height
                let duration = isShow ? 0.6 : 0.9
                if isShow {
                    self.isHidden = false
                }
                UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: [.preferredFramesPerSecond60]) {
                    if isShow {
                        self.frame = .init(origin: .init(x: centerX, y: endPosY), size: self.frame.size)
                    } else {
                        self.frame = .init(origin: .init(x: centerX, y: startPosY), size: self.frame.size)
                    }
                } completion: { _ in
                    self.isHidden = !isShow
                }
            }
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.superViewFrame = self.superview?.frame
        if let connectivityShared = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.connectivity{
            self.isConnected = connectivityShared.isConnected
        }
    }
    
    @objc private func didConnectionChanged(notification: NSNotification){
        if let connectivity = notification.object as? Connectivity{
            self.isConnected = connectivity.isConnected
        }
    }
}
