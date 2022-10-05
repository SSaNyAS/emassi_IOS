//
//  PublicRequestPresenter.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 03.10.2022.
//

import Foundation
protocol PublicRequestPresenterDelegate: AnyObject{
    func addPhoto()
    func createPublicRequest()
}

class PublicRequestPresenter: PublicRequestPresenterDelegate{
    
    
    var interactor: PublicRequestInteractorDelegate
    weak var router: RouterDelegate?
    weak var viewDelegate: PublicRequestViewDelegate?
    public var selectedCategory: String?
    
    init(interactor: PublicRequestInteractorDelegate) {
        self.interactor = interactor
    }
    
    func addPhoto() {
        if let viewController = viewDelegate?.getViewController(){
            router?.goToViewController(from: viewController, to: .imagePicker({ [weak self] selectedImage in
                self?.setPhoto(imageData: selectedImage.compressedData())
            }, nil), presentationMode: .present)
        }
    }
    
    func createPublicRequest() {
        interactor.createPublicRequest { [weak self] workId, apiResponse, error in
            if apiResponse?.isErrored == false{
                
            }
            self?.viewDelegate?.showMessage(message: error?.localizedDescription ?? apiResponse?.message ?? "", title: "")
        }
    }
    
    func setPhoto(imageData: Data?){
        viewDelegate?.addPhoto(imageData: imageData)
    }
    
}
