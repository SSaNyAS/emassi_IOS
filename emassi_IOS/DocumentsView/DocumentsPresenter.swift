//
//  DocumentsPresenter.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 28.09.2022.
//

import Foundation
protocol DocumentsPresenterDelegate{
    func loadDocuments()
}

class DocumentsPresenter: DocumentsPresenterDelegate{
    var interactor: DocumentsInteractorDelegate
    var dataSource: DocumentsTableViewDataSource
    weak var router: RouterDelegate?
    weak var viewDelegate: DocumentsViewDelegate?
    
    init(interactor: DocumentsInteractorDelegate) {
        self.interactor = interactor
        dataSource = DocumentsTableViewDataSource()
        dataSource.loadAction = { [weak self] document in
            self?.uploadImage(for: document)
        }
        dataSource.getDocImage = {[weak self] docId, completion in
            self?.loadDocumentImage(documentId: docId, completion: completion)
        }
    }
    
    func loadDocumentImage(documentId: String, completion: @escaping (Data?) -> Void){
        interactor.getDocumentImage(docId: documentId) { imageData, apiResponse, message in
            completion(imageData)
        }
    }
    
    func loadDocuments(){
        interactor.getPerformerDocuments {[weak self] documents, apiResponse, message in
            guard let self = self else {return}
            self.dataSource.documents = documents
            self.viewDelegate?.setTableViewDataSource(dataSource: self.dataSource)
            self.viewDelegate?.reloadData()
        }
    }
    
    func uploadImage(for document: Photo){
        let imagePicker = EmassiRoutedViews.imagePicker({[weak self] selectedImage in
            self?.interactor.uploadDocument(document: document, documentJpegData: selectedImage.jpegData(compressionQuality: 0.5)!, completion: { [weak self] apiResponse, message in
                self?.viewDelegate?.showMessage(message: message ?? "", title: "")
            })
        }, nil)
        
        if let viewController = self.viewDelegate?.getViewController(){
            router?.goToViewController(from: viewController, to: imagePicker, presentationMode: .present)
        }
    }
}
