//
//  UIViewControllerExtension.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 12.09.2022.
//

import Foundation
import UIKit
extension UIViewController{
    
    func showMessage(message: String){
        DispatchQueue.main.async {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertController.addAction(.init(title: "OK", style: .cancel))
        
            self.present(alertController, animated: true)
        }
    }
    
    func showMessage(message: String, title: String){
        DispatchQueue.main.async {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(.init(title: "OK", style: .cancel))
        
            self.present(alertController, animated: true)
        }
    }
    
}
