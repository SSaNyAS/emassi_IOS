//
//  MenuNavigationViewController.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 07.09.2022.
//

import Foundation
import UIKit

class MenuNavigationViewController: UINavigationController {
    
    public var menuAnimationDuration = 0.7
    private var menuViewController: UIViewController?
    private var isOpenedMenu: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setupMenuViewController()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupMenuViewController()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        let backImage = UIImage(systemName: "chevron.left")
        let goBackBarButton = UIBarButtonItem(image: backImage, style: .done, target: self, action: #selector(goBack))
        goBackBarButton.tintColor = .black
        
        let horizontalLinesImage = UIImage(systemName: "line.3.horizontal")
        let openMenuBarButton = UIBarButtonItem(image: horizontalLinesImage, style: .done, target: self, action: #selector(toggleMenu))
        openMenuBarButton.tintColor = .black
        
        viewController.navigationItem.leftBarButtonItem = goBackBarButton
        viewController.navigationItem.rightBarButtonItem = openMenuBarButton
        
        super.pushViewController(viewController, animated: animated)
    }
    @objc func goBack(){
        popViewController(animated: true)
    }
    
    @objc func toggleMenu(){
        isOpenedMenu.toggle()
        guard let menuView = menuViewController?.view else { return }
        guard let currentView = topViewController?.view else {return}
        
        let menuStartXposition = currentView.frame.width
        let menuEndXposition = menuStartXposition * 0.33
        
        if isOpenedMenu{
            let blackView = UIView(frame: currentView.frame)
            blackView.alpha = 0.9
            blackView.backgroundColor = .black
            blackView.isUserInteractionEnabled = false
            currentView.isUserInteractionEnabled = false
            currentView.mask = blackView
        } else{
            currentView.isUserInteractionEnabled = true
            currentView.mask = nil
        }
        
        UIView.animate(withDuration: menuAnimationDuration) { [weak self] in
            guard let self = self else {return}
            menuView.frame.origin = self.isOpenedMenu ? CGPoint.init(x: menuEndXposition, y: 0) : CGPoint.init(x: menuStartXposition, y: 0)
        } completion: { isSuccess in
            
        }
    }
    
    func setupMenuViewController(){
        let menuVC = getMenuViewController()
        
        guard let currentView = topViewController?.view else {return}
        
        let menuStartXposition = currentView.frame.width
        let menuSize = CGSize(width: currentView.frame.width * 0.66, height: currentView.frame.height)
        
        let menuStartFrame = CGRect(origin: .init(x: menuStartXposition, y: 0), size: menuSize)
        
        menuVC.view.frame = menuStartFrame
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(toggleMenu))
        swipeGesture.direction = .right
        menuVC.view.addGestureRecognizer(swipeGesture)
        
        view.addSubview(menuVC.view)
        //addChild(menuVC)
        menuViewController = menuVC
    }
    
    func getMenuViewController() -> MenuViewController{
        let menuViewController: MenuViewController = MenuViewController()
        return menuViewController
    }

}
