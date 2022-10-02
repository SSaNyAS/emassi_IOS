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
    
    func setRootViewController(routedView: EmassiRoutedViews){
        
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

enum EmassiRoutedViews: Equatable, RawRepresentable{
    
    case onboarding
    case login
    case register
    case categories
    case favorites
    case documents
    case activeWorks
    case settings
    case feedback
    case performersList(_ categoryId: String)
    case performerInfo(_ performerId: String)
    case createOrder
    case resetPassword
    case performerProfile
    case createRequest(_ performerId: String)
    case imagePicker(_ didSelectAction: ((UIImage) -> Void)?,_ didCancelPickImage: (()->Void)?)
    case addressSelector(_ searchText: String? = nil, _ didSelectAddressAction: ((Address) -> Void)?)
    
    
    
    init?(rawValue: String) {
        if rawValue == "login"{
            self = .login
        }
        if rawValue == "register"{
            self = .register
        }
        self = .onboarding
    }
    
    var rawValue: String{
        switch self {
        case .onboarding:
            return "onboarding"
        case .login:
            return "login"
        case .register:
            return "register"
        case .categories:
            return "categories"
        case .favorites:
            return "favorites"
        case .documents:
            return "documents"
        case .activeWorks:
            return "activeWorks"
        case .settings:
            return "settings"
        case .feedback:
            return "feedback"
        case .performersList(let category):
            return "performersListForCategory\(category)"
        case .performerInfo(let performer):
            return "performerInfoForPerformer\(performer)"
        case .createOrder:
            return "createOrder"
        case .resetPassword:
            return "resetPassword"
        case .performerProfile:
            return "performerProfile"
        case .createRequest:
            return "createRequest"
        case .imagePicker(_,_):
            return "imagePicker"
        case .addressSelector(_,_):
            return "addressSelector"
        }
    }
    
    typealias RawValue = String
    
    static func == (lhs: EmassiRoutedViews, rhs: EmassiRoutedViews) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
    
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
                let presenter = LoginPresenter(interactor: interactor,router: router)
                presenter.loginView = loginVC
                presenter.router = router
                loginVC.presenter = presenter
            }
            SessionConfiguration.isDontNeedShowOnboarding = true
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
            SessionConfiguration.isDontNeedShowOnboarding = true
            authorizationData?.setupRegisterViewController(registerVC: registerVC)
            return registerVC
        case .categories:
            let categoriesVC = PerformersCategoriesViewController()
            if let api = router?.emassiApi{
                let interactor = PerformersCategoriesInteractor(emassiApi: api)
                let presenter = PerformersCategoriesPresenter(interactor: interactor)
                presenter.viewDelegate = categoriesVC
                presenter.router = router
                categoriesVC.presenter = presenter
            }
            let menuNavigationController = MenuNavigationViewController(rootViewController: categoriesVC)
            menuNavigationController.router = router
            router?.authorizationData = nil
            return menuNavigationController
        case .favorites:
            let favoritesVC = FavoriteViewController()
            return favoritesVC
        case .documents:
            let documentsVC = DocumentsViewController()
            if let api = router?.emassiApi{
                let interactor = DocumentsInteractor(emassiApi: api)
                let presenter = DocumentsPresenter(interactor: interactor)
                documentsVC.presenter = presenter
                presenter.viewDelegate = documentsVC
                presenter.router = router
            }
            return documentsVC
        case .activeWorks:
            let worksRequestVC = WorksRequestViewController()
            if let api = router?.emassiApi{
                let interactor = WorksRequestInteractor(emassiApi: api)
                let presenter = WorksRequestPresenter(interactor: interactor)
                presenter.viewDelegate = worksRequestVC
                presenter.router = router
                worksRequestVC.presenter = presenter
            }
            return worksRequestVC
        case .settings:
            let settingsVC = SettingsViewController()
            return settingsVC
        case .feedback:
            let feedbackVC = FeedbackViewController()
            return feedbackVC
        case .createOrder:
            let createOrderVC = CreateOrderViewController()
            return createOrderVC
        case .createRequest(let performerId):
            let createRequestVC = CreateRequestViewController()
            if let api = router?.emassiApi{
                let interactor = CreateRequestInteractor(emassiApi: api)
                let presenter = CreateRequestPresenter(interactor: interactor, performerId: performerId)
                presenter.router = router
                presenter.viewDelegate = createRequestVC
                createRequestVC.presenter = presenter
            }
            return createRequestVC
        case .performersList(let category):
            let performersListVC = PerformersListViewController()
            if let api = router?.emassiApi{
                let interactor = PerformersListInteractor(emassiApi: api)
                let presenter = PerformersListPresenter(interactor: interactor, category: category)
                performersListVC.presenter = presenter
                presenter.viewDelegate = performersListVC
                presenter.router = router
            }
            return performersListVC
        case .performerInfo(let performerId):
            let performerInfoVC = PerformerInfoViewController()
            if let api = router?.emassiApi{
                let interactor = PerformerInfoInteractor(emassiApi: api)
                let presenter = PerformerInfoPresenter(interactor: interactor, performerId: performerId)
                presenter.viewDelegate = performerInfoVC
                presenter.router = router
                performerInfoVC.presenter = presenter
            }
            return performerInfoVC
        case .performerProfile:
            let profileVC = PerformerProfileViewController()
            if let api = router?.emassiApi{
                let interactor = PerformerProfileInteractor(emassiApi: api)
                let presenter = PerformerProfilePresenter(interactor: interactor)
                presenter.router = router
                presenter.viewDelegate = profileVC
                profileVC.presenter = presenter
            }
            return profileVC
        case .resetPassword:
            let resetPasswordVC = ResetPasswordViewController()
            if let api = router?.emassiApi{
                let interactor = ResetPasswordInteractor(emassiApi: api)
                let presenter = ResetPasswordPresenter(interactor: interactor)
                resetPasswordVC.presenter = presenter
                presenter.viewDelegate = resetPasswordVC
            }
            return resetPasswordVC
        case .imagePicker(let didSelectAction, let didCancel):
            let imagePickerVC = ImagePickerController()
            imagePickerVC.didCancelPickImage = didCancel
            imagePickerVC.didSelectImageAction = didSelectAction
            return imagePickerVC
        case .addressSelector(let searchText, let didSelectAddressAction):
            let addressSelectViewController = AddressSearchViewController()
            addressSelectViewController.searchController.searchBar.text = searchText
            addressSelectViewController.didSelectAddressAction = didSelectAddressAction
            let navigationController = UINavigationController(rootViewController: addressSelectViewController)
            return navigationController
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
