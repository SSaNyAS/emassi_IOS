//
//  EmassiRouter.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 12.09.2022.
//

import Foundation
import UIKit
import CoreLocation.CLLocation

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
    var currentView: EmassiRoutedViews = .onboarding
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
            if presentationMode == .push{
                
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

enum EmassiRoutedViews: Equatable, RawRepresentable{
    
    case onboarding
    case login
    case register
    case categories
    case favorites
    case documents
    case myWorks
    case activeWorks(isShowActive: Bool)
    case ordersList
    case settings
    case feedback(_ workId: String, _ profileMode: ProfileMode = .customer)
    case orderInfo(_ workId: String, profileMode: ProfileMode = .performer)
    case sendOfferForWork(_ workId: String)
    case performersList(_ categoryId: String)
    case performerInfo(_ performerId: String)
    case createPublicRequest(_ categoryId: String?)
    case resetPassword
    case performerProfile
    case createRequest(_ performerId: String, _ categoryId: String?)
    case imagePicker(_ didSelectAction: ((UIImage) -> Void)?,_ didCancelPickImage: (()->Void)?)
    case addressSelector(_ searchText: String? = nil, _ didSelectAddressAction: ((Address, CLLocation?) -> Void)?)
    case calendar
    
    
    
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
        case .myWorks:
            return "myWorks"
        case .activeWorks(let isShowActive):
            return "activeWorksIsShowActive\(isShowActive)"
        case .ordersList:
            return "ordersList"
        case .settings:
            return "settings"
        case .feedback(let workId, let profileMode):
            return "feedbackForWork\(workId)\(profileMode)"
        case .orderInfo(let workId,let profileMode):
            return "orderInfo\(workId)\(profileMode)"
        case .sendOfferForWork(let workId):
            return "sendOfferForWork\(workId)"
        case .performersList(let category):
            return "performersListForCategory\(category)"
        case .performerInfo(let performer):
            return "performerInfoForPerformer\(performer)"
        case .resetPassword:
            return "resetPassword"
        case .performerProfile:
            return "performerProfile"
        case .createRequest(let performer,let category):
            return "createRequest\(performer)_\(String(describing: category))"
        case .createPublicRequest(let category):
            return "createPublicRequest\(String(describing: category))"
        case .imagePicker(_,_):
            return "imagePicker"
        case .addressSelector(_,_):
            return "addressSelector"
        case .calendar:
            return "calendar"
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
            onboardingVC.router = router
            return onboardingVC
        case .login:
            let loginVC = LoginViewController()
            if let api = router?.emassiApi {
                let interactor = LoginInteractor(api: api)
                let presenter = LoginPresenter(interactor: interactor,router: router)
                presenter.loginView = loginVC
                presenter.router = router
                loginVC.presenter = presenter
                loginVC.subscribeToCheckConnection()
                loginVC.subscribeToHideKeyboardWhenTappedAround()
                loginVC.subscribeToCheckKeyboardSize()
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
                registerVC.subscribeToCheckConnection()
                registerVC.subscribeToHideKeyboardWhenTappedAround()
                registerVC.subscribeToCheckKeyboardSize()
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
                categoriesVC.subscribeToCheckConnection()
                categoriesVC.subscribeToCheckKeyboardSize()
            }
            let menuNavigationController = MenuNavigationViewController(rootViewController: categoriesVC)
            menuNavigationController.router = router
            menuNavigationController.subscribeToHideKeyboardWhenTappedAround()
            router?.authorizationData = nil
            return menuNavigationController
        case .favorites:
            let favoritesVC = FavoriteViewController()
            if let api = router?.emassiApi{
                let interactor = FavoriteInteractor(emassiApi: api)
                let presenter = FavoritePresenter(interactor: interactor)
                presenter.router = router
                presenter.viewDelegate = favoritesVC
                favoritesVC.presenter = presenter
                
                favoritesVC.subscribeToCheckConnection()
                favoritesVC.subscribeToCheckKeyboardSize()
            }
            return favoritesVC
        case .documents:
            let documentsVC = DocumentsViewController()
            if let api = router?.emassiApi{
                let interactor = DocumentsInteractor(emassiApi: api)
                let presenter = DocumentsPresenter(interactor: interactor)
                documentsVC.presenter = presenter
                presenter.viewDelegate = documentsVC
                presenter.router = router
                
                documentsVC.subscribeToCheckConnection()
                documentsVC.subscribeToCheckKeyboardSize()
            }
            return documentsVC
        case .myWorks:
            let worksRequestVC = WorksRequestViewController()
            if let api = router?.emassiApi{
                let interactor = WorksRequestInteractor(emassiApi: api)
                let presenter = WorksRequestPresenter(interactor: interactor)
                presenter.viewDelegate = worksRequestVC
                presenter.router = router
                worksRequestVC.presenter = presenter
                
                worksRequestVC.subscribeToCheckConnection()
                worksRequestVC.subscribeToCheckKeyboardSize()
            }
            return worksRequestVC
        case .activeWorks(let isShowActive):
            let activeWorksVC = ActiveWorksViewController()
            if let api = router?.emassiApi{
                let interactor = ActiveWorksInteractor(emassiApi: api)
                let presenter = ActiveWorksPresenter(interactor: interactor)
                presenter.router = router
                presenter.viewDelegate = activeWorksVC
                presenter.isShowActive = isShowActive
                activeWorksVC.presenter = presenter
                activeWorksVC.subscribeToCheckConnection()
                activeWorksVC.subscribeToCheckKeyboardSize()
            }
            return activeWorksVC
        case .ordersList:
            let ordersListVC = OrdersListViewController()
            if let api = router?.emassiApi{
                let interactor = OrdersListInteractor(emassiApi: api)
                let presenter = OrdersListPresenter(interactor: interactor)
                presenter.router = router
                presenter.viewDelegate = ordersListVC
                ordersListVC.presenter = presenter
                ordersListVC.subscribeToCheckConnection()
                ordersListVC.subscribeToCheckKeyboardSize()
            }
            return ordersListVC
        case .orderInfo(let workId,let profileMode):
            let orderInfoVC = OrderInfoViewController()
            if let api = router?.emassiApi{
                let interactor = OrderInfoInteractor(emassiApi: api)
                let presenter = OrderInfoPresenter(interactor: interactor, workId: workId, profileMode: profileMode)
                presenter.router = router
                presenter.viewDelegate = orderInfoVC
                orderInfoVC.presenter = presenter
                orderInfoVC.subscribeToCheckConnection()
                orderInfoVC.subscribeToCheckKeyboardSize()
            }
            return orderInfoVC
        case .settings:
            let settingsVC = SettingsViewController()
            settingsVC.subscribeToCheckConnection()
            settingsVC.subscribeToCheckKeyboardSize()
            return settingsVC
        case .feedback(let workId, let profileMode):
            let feedbackVC = FeedbackViewController()
            if let api = router?.emassiApi{
                let interactor = SendFeedbackInteractor(emassiApi: api)
                let presenter = SendFeedbackPresenter(interactor: interactor, profileMode: profileMode)
                presenter.router = router
                presenter.viewDelegate = feedbackVC
                presenter.workId = workId
                feedbackVC.presenter = presenter
                feedbackVC.subscribeToCheckConnection()
                feedbackVC.subscribeToCheckKeyboardSize()
            }
            return feedbackVC
        case .sendOfferForWork(let workId):
            let sendOfferVC = SendOfferViewController()
            sendOfferVC.workId = workId
            sendOfferVC.emassiApi = router?.emassiApi
            
            sendOfferVC.subscribeToCheckConnection()
            sendOfferVC.subscribeToHideKeyboardWhenTappedAround()
            sendOfferVC.subscribeToCheckKeyboardSize()
            return sendOfferVC
        case .createPublicRequest(let category):
            let publicRequestVC = PublicRequestViewController()
            if let api = router?.emassiApi{
                let interactor = PublicRequestInteractor(emassiApi: api)
                let presenter = PublicRequestPresenter(interactor: interactor)
                presenter.router = router
                presenter.viewDelegate = publicRequestVC
                presenter.selectedCategory = category
                publicRequestVC.presenter = presenter
                
                publicRequestVC.subscribeToCheckConnection()
                publicRequestVC.subscribeToHideKeyboardWhenTappedAround()
                publicRequestVC.subscribeToCheckKeyboardSize()
            }
            return publicRequestVC
        case .createRequest(let performerId, let category):
            let createRequestVC = CreateRequestViewController()
            if let api = router?.emassiApi{
                let interactor = CreateRequestInteractor(emassiApi: api)
                let presenter = CreateRequestPresenter(interactor: interactor, performerId: performerId)
                presenter.selectedCategory = category
                presenter.router = router
                presenter.viewDelegate = createRequestVC
                createRequestVC.presenter = presenter
                
                createRequestVC.subscribeToCheckConnection()
                createRequestVC.subscribeToHideKeyboardWhenTappedAround()
                createRequestVC.subscribeToCheckKeyboardSize()
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
                
                performersListVC.subscribeToCheckConnection()
                performersListVC.subscribeToCheckKeyboardSize()
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
                
                performerInfoVC.subscribeToCheckConnection()
                performerInfoVC.subscribeToCheckKeyboardSize()
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
                
                profileVC.subscribeToCheckConnection()
                profileVC.subscribeToCheckKeyboardSize()
            }
            return profileVC
        case .resetPassword:
            let resetPasswordVC = ResetPasswordViewController()
            if let api = router?.emassiApi{
                let interactor = ResetPasswordInteractor(emassiApi: api)
                let presenter = ResetPasswordPresenter(interactor: interactor)
                resetPasswordVC.presenter = presenter
                presenter.viewDelegate = resetPasswordVC
                
                resetPasswordVC.subscribeToCheckConnection()
                resetPasswordVC.subscribeToHideKeyboardWhenTappedAround()
                resetPasswordVC.subscribeToCheckKeyboardSize()
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
            navigationController.subscribeToCheckKeyboardSize()
            navigationController.subscribeToHideKeyboardWhenTappedAround()
            return navigationController
        case .calendar:
            let calendarVC = CalendarViewController()
            if let api = router?.emassiApi{
                let interactor = CalendarInteractor(emassiApi: api)
                let presenter = CalendarPresenter(interactor: interactor)
                presenter.router = router
                presenter.viewDelegate = calendarVC
                calendarVC.presenter = presenter
            }
            return calendarVC
        }
    }
}


enum ViewControllerPresentMode: Equatable{
    case present
    case push
    case popToRoot
    case pop
    case presentFullScreen
    case modal
    case custom(UIModalPresentationStyle, UIModalTransitionStyle)
}
