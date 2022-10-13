//
//  MenuNavigationViewController.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 07.09.2022.
//

import Foundation
import UIKit

class MenuNavigationViewController: UINavigationController {
    weak var router: RouterDelegate?{
        didSet{
            menuViewController?.router = router
        }
    }
    public var menuAnimationDuration = 0.7
    private var menuViewController: MenuViewController?
    private var isOpenedMenu: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isUserInteractionEnabled = true
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setupMenuViewController()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupMenuViewController()
    }
    
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        if isOpenedMenu {
            toggleMenu()
        }
        return super.popToViewController(viewController, animated: animated)
    }
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        if isOpenedMenu {
            toggleMenu()
        }
        return super.popToRootViewController(animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        if isOpenedMenu {
            toggleMenu()
        }
        return super.popViewController(animated: animated)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        let goBackBarButton = UIBarButtonItem()
        goBackBarButton.tintColor = .invertedSystemBackground
        
        let horizontalLinesImage = UIImage(systemName: "line.3.horizontal")?.applyingSymbolConfiguration(.init(weight: .bold))
        
        let openMenuBarButton = UIBarButtonItem(image: horizontalLinesImage, style: .done, target: self, action: #selector(toggleMenu))
        openMenuBarButton.tintColor = .invertedSystemBackground
        
        viewController.navigationItem.rightBarButtonItem = openMenuBarButton
        viewController.navigationItem.backBarButtonItem = goBackBarButton
        if isOpenedMenu {
            toggleMenu()
        }
        let firstWhereTypeEquals = viewControllers.first(where: {type(of: $0) == type(of: viewController)})
        if let viewControllerOld = firstWhereTypeEquals{
            super.popToViewController(viewControllerOld, animated: true)
            return
        }
        if let lastVC = viewControllers.last{
            if type(of: lastVC) == type(of: viewController){
                super.popViewController(animated: true)
                return
            }
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc func goBack(){
        _ = popViewController(animated: true)
    }
    
    @objc func toggleMenu(){
        isOpenedMenu.toggle()
        changeMenu()
    }
    
    
    
    private func changeMenu(){
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
        updateMenuViewController()
        UIView.animate(withDuration: menuAnimationDuration) { [weak self] in
            guard let self = self else {return}
            menuView.frame.origin = self.isOpenedMenu ? CGPoint.init(x: menuEndXposition, y: 0) : CGPoint.init(x: menuStartXposition, y: 0)
        }
    }
    
    private func updateMenuViewController(){
        if let router = router as? EmassiRouter{
            router.emassiApi.getAccountInfo { [weak menuViewController] accountinfo, apiResponse, error in
                DispatchQueue.main.async {
                    menuViewController?.nameLabel?.text = accountinfo?.username.common
                    router.emassiApi.downloadCustomerPhotoPublic { [weak menuViewController] imageData, apiResponse in
                        DispatchQueue.main.async {
                            menuViewController?.profileImageView?.image = UIImage(data: imageData ?? Data()) ?? .noPhotoUser
                        }
                    }
                    
                }
            }
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
        menuViewController.menuNavigationController = self
        menuViewController.router = router
        return menuViewController
    }

}
