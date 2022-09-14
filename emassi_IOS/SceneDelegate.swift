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
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let api = EmassiApi(apiKey: apiKey, skey: skey)
        emassiApi = api
        
        router = EmassiRouter(emassiApi: api)
        router?.setRootViewController(for: window, routedView: .categories)
//        window?.makeKeyAndVisible()
//        window?.rootViewController = FavoriteViewController()
        //MenuNavigationViewController(rootViewController: PerformersCategoriesViewController())
    }
}

