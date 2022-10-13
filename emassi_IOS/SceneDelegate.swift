//
//  SceneDelegate.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 01.09.2022.
//

import UIKit
import Connectivity

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var router: EmassiRouter?
    
    let apiKey = "api_c21c39e97c8c58d2909c4b6fbdb7d3c9"
    let skey = "skey_f19da651f0c2f96afb46b37f6e80a939"
    
    var emassiApi: EmassiApi?
    var connectivity: Connectivity?
    
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
        connectivity = Connectivity()
        connectivity?.isPollingEnabled = true
        let dispatchQueue = DispatchQueue(label: "networkCheck")
        connectivity?.startNotifier(queue: dispatchQueue)
        
        let navigationController = UINavigationController()
        navigationController.isToolbarHidden = true
        navigationController.isNavigationBarHidden = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        func setLoginViewOrOnboarding(){
            guard let navigationController = window?.rootViewController as? UINavigationController else {
                return
            }
            if SessionConfiguration.isDontNeedShowOnboarding == false {
                navigationController.viewControllers = [EmassiRoutedViews.onboarding.viewController]
            }
            else {
                navigationController.viewControllers = [EmassiRoutedViews.login.viewController]
            }
        }
        
        if api.isValidToken{
            if connectivity?.isConnected == true{
                api.getAccountInfo { [weak navigationController] info, apiResponse, error in
                    guard let apiResponse = apiResponse else {
                        setLoginViewOrOnboarding()
                        return
                    }
                    if (apiResponse.isErrored) == false {
                        DispatchQueue.main.async { [weak navigationController] in
                            let categoriesVC = EmassiRoutedViews.categories.viewController
                            categoriesVC.modalPresentationStyle = .fullScreen
                            navigationController?.present(categoriesVC, animated: true)
                        }
                    } else {
                        setLoginViewOrOnboarding()
                    }
                }
            } else {
                setLoginViewOrOnboarding();
                #warning("Здесь лучше всего реализовать экран где будет отображаться, что нет подключения, где после появления подключения будет проверка аккаунта и открытие либо авторизации либо основного экрана приложения")
            }
        } else {
            setLoginViewOrOnboarding()
        }
    }
}

