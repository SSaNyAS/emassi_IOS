//
//  SceneDelegate.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 01.09.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var router: EmassiRouter?
    
    let apiKey = "api_c21c39e97c8c58d2909c4b6fbdb7d3c9"
    let skey = "skey_f19da651f0c2f96afb46b37f6e80a939"
    
    var emassiApi: EmassiApi?
    var networkMonitor: NetworkConnectionChecker?
    
    @objc private func didLogout(){
        if (emassiApi?.isValidToken ?? true) == false {
            if let navigationViewController = window?.rootViewController as? UINavigationController{
                navigationViewController.viewControllers = [EmassiRoutedViews.login.viewController]
                navigationViewController.presentedViewController?.dismiss(animated: true)
            }
        }
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let api = EmassiApi(apiKey: apiKey, skey: skey)
        emassiApi = api
        
        NotificationCenter.default.addObserver(self, selector: #selector(didLogout), name: .logoutNotification, object: nil)
        
        router = EmassiRouter(emassiApi: api)
        networkMonitor = NetworkConnectionChecker()
        networkMonitor?.connectionChanged = { isConnected in
            print("connection changed, connection is successfull: \(isConnected)")
        }
        networkMonitor?.networkTypeChanged = { connectionType in
            print("connection type changed, new type is \(connectionType.rawValue)")
        }
        let navigationController = UINavigationController()
        navigationController.isToolbarHidden = true
        navigationController.isNavigationBarHidden = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        if SessionConfiguration.isDontNeedShowOnboarding == false {
            navigationController.viewControllers = [EmassiRoutedViews.onboarding.viewController]
        }
        else {
            navigationController.viewControllers = [EmassiRoutedViews.login.viewController]
        }
    }
}

