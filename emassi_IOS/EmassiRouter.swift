//
//  EmassiRouter.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 12.09.2022.
//

import Foundation
import UIKit

protocol RouterDelegate: NSObject{
    func goToViewController(from viewController: UIViewController, to routedView: EmassiRoutedViews, presentationMode: ViewControllerPresentMode)
    func setRootViewController(for window: UIWindow?, routedView: EmassiRoutedViews)
}

public class EmassiRouter:NSObject, RouterDelegate{
    
    @MainActor
    static var instance: EmassiRouter?{
        return (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.router
    }
    
    var emassiApi: EmassiApi
    var authorizationData: AuthorizationViewsData?
    
    init(emassiApi: EmassiApi){
        self.emassiApi = emassiApi
    }
    
    @MainActor
    func setRootViewController(for window: UIWindow?, routedView: EmassiRoutedViews) {
        window?.rootViewController = routedView.viewController
        window?.makeKeyAndVisible()
    }
    
    func goToViewController(from viewController: UIViewController, to routedView: EmassiRoutedViews, presentationMode: ViewControllerPresentMode) {
        DispatchQueue.main.async { [weak self] in
            let showingVC = routedView.viewController
            if routedView == .register || routedView == .login {
                if viewController.presentingViewController is LoginViewController || viewController.presentingViewController is RegisterViewController{
                    viewController.dismiss(animated: true)
                    return
                }
            }
            self?.presentWithMode(from: viewController, to: showingVC, presentMode: presentationMode)
        }
    }
    
    @MainActor
    private func presentWithMode(from viewController: UIViewController, to presentedViewController: UIViewController, presentMode: ViewControllerPresentMode){
        switch presentMode {
        case .present:
            viewController.present(presentedViewController, animated: true)
        case .push:
            viewController.navigationController?.pushViewController(presentedViewController, animated: true)
        case .popToRoot:
            _ = viewController.navigationController?.popToRootViewController(animated: true)
        case .pop:
            _ = viewController.navigationController?.popViewController(animated: true)
        case .presentFullScreen:
            presentedViewController.modalPresentationStyle = .fullScreen
            viewController.present(presentedViewController, animated: true)
        case .modal:
            viewController.present(presentedViewController, animated: true)
        case .custom(let modalPresentationStyle, let modalTransitionStyle):
            presentedViewController.modalPresentationStyle = modalPresentationStyle
            presentedViewController.modalTransitionStyle = modalTransitionStyle
            viewController.present(presentedViewController, animated: true)
        }
    }
}

enum EmassiRoutedViews{
    case onboarding
    case login
    case register
    case categories
    case favorites
    case documents
    case workOrders
    case settings
    case feedback
    case createOrder
    case resetPassword
    
    @MainActor
    public var viewController: UIViewController{
        let router = EmassiRouter.instance
        if self == .login || self == .register{
            if router?.authorizationData == nil{
                router?.authorizationData = .init()
            }
        }
        let authorizationData = router?.authorizationData
        
        switch self{
        case .onboarding:
            let onboardingVC = OnboardingViewController()
            onboardingVC.router = EmassiRouter.instance
            return onboardingVC
        case .login:
            let loginVC = LoginViewController()
            if let api = router?.emassiApi {
                let interactor = LoginInteractor(api: api)
                let presenter = LoginPresenter(interactor: interactor)
                loginVC.presenter = presenter
                presenter.loginView = loginVC
                presenter.router = router
            }
            
            authorizationData?.setupLoginViewController(loginVC: loginVC)
            return loginVC
        case .register:
            let registerVC = RegisterViewController()
            if let api = router?.emassiApi {
                let interactor = RegisterInteractor(api: api)
                let presenter = RegisterPresenter(interactor: interactor)
                registerVC.presenter = presenter
                presenter.registerView = registerVC
                presenter.router = router
            }
            
            authorizationData?.setupRegisterViewController(registerVC: registerVC)
            return registerVC
        case .categories:
            let categoriesVC = PerformersCategoriesViewController()
            let menuNavigationController = MenuNavigationViewController(rootViewController: categoriesVC)
            menuNavigationController.router = router
            return menuNavigationController
        case .favorites:
            let favoritesVC = FavoriteViewController()
            return favoritesVC
        case .documents:
            let documentsVC = DocumentsViewController()
            return documentsVC
        case .workOrders:
            let workOrdersVC = WorkOrdersViewController()
            return workOrdersVC
        case .settings:
            let settingsVC = SettingsViewController()
            return settingsVC
        case .feedback:
            let feedbackVC = FeedbackViewController()
            return feedbackVC
        case .createOrder:
            let createOrderVC = CreateOrderViewController()
            return createOrderVC
        case .resetPassword:
            let resetPasswordVC = ResetPasswordViewController()
            if let api = router?.emassiApi{
                let interactor = ResetPasswordInteractor(emassiApi: api)
                let presenter = ResetPasswordPresenter(interactor: interactor)
                resetPasswordVC.presenter = presenter
                presenter.viewDelegate = resetPasswordVC
            }
            return resetPasswordVC
        }
        
    }
}


enum ViewControllerPresentMode{
    case present
    case push
    case popToRoot
    case pop
    case presentFullScreen
    case modal
    case custom(UIModalPresentationStyle, UIModalTransitionStyle)
}
