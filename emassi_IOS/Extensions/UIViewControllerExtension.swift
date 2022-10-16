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
    
    func subscribeToCheckConnection(){
        let containsSubscriber = self.view.subviews.contains { view in
            view is NetworkErrorView
        }
        guard containsSubscriber == false else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+2){
            let connectionView = NetworkErrorView()
            self.view.addSubview(connectionView)
        }
    }
    
    func subscribeToCheckKeyboardSize(){
        let containsSubscriber = self.view.subviews.contains { view in
            return view is KeyboardObserverView
        }
        guard containsSubscriber == false else {
            return
        }
        DispatchQueue.main.async {
            let observerView = KeyboardObserverView()
            observerView.frame = .zero
            self.view.addSubview(observerView)
        }
    }
    
    func subscribeToHideKeyboardWhenTappedAround(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
}
