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
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alertController.addAction(.init(title: "OK", style: .cancel))
        
            self.present(alertController, animated: true)
        }
    }
    
}
