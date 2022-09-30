//
//  DocumentsInteractor.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 28.09.2022.
//

import Foundation
protocol DocumentsInteractorDelegate{
    func uploadDocument(document: Photo, documentJpegData: Data, completion: @escaping (_ apiResponse: EmassiApiResponse?, _ message: String?) -> Void)
    func getDocumentImage(docId: String, completion: @escaping (_ imageData: Data?, _ apiResponse: EmassiApiResponse?, _ message: String?) -> Void)
    func getPerformerDocuments(completion: @escaping (_ documents: [Photo], _ apiResponse: EmassiApiResponse?, _ message: String?) -> Void)
}

class DocumentsInteractor: DocumentsInteractorDelegate{
    weak var emassiApi: EmassiApi?
    private var defaultDocuments: [Photo] = [
        .init(id: "", name: "ИНН"),
        .init(id: "", name: "Удостоверение личности")
    ]
    
    init(emassiApi: EmassiApi) {
        self.emassiApi = emassiApi
    }
    
    func getPerformerDocuments(completion: @escaping (_ documents: [Photo], _ apiResponse: EmassiApiResponse?, _ message: String?) -> Void){
        emassiApi?.getPerformerProfile(completion: { [weak self] profile, apiResponse, error in
            var documents = profile?.photos ?? []
            for defaultDocument in self?.defaultDocuments ?? []{
                if (documents.contains(where: { document in
                    document.name == defaultDocument.name
                })) == false{
                    documents.append(defaultDocument)
                }
            }
                
            completion(documents,apiResponse, error?.localizedDescription ?? apiResponse?.message)
        })
    }
    
    func getDocumentImage(docId: String, completion: @escaping (_ imageData: Data?, _ apiResponse: EmassiApiResponse?, _ message: String?) -> Void) {
        emassiApi?.getPerformerDocs(docId: docId, completion: { data, apiResponse, error in
            completion(data, apiResponse, error?.localizedDescription ?? apiResponse?.message)
        })
    }
    
    func uploadDocument(document: Photo, documentJpegData: Data, completion: @escaping (_ apiResponse: EmassiApiResponse?, _ message: String?) -> Void) {
        emassiApi?.uploadPerformerDocs(photoJpeg: documentJpegData, documentType: document.type, documentName: document.name, completion: { apiResponse, error in
            completion(apiResponse, error?.localizedDescription ?? apiResponse?.message)
        })
    }
}
