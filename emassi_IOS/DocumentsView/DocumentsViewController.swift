//
//  DocumentsViewController.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 12.09.2022.
//

import Foundation
import UIKit
protocol DocumentsViewDelegate: AnyObject{
    func getViewController() -> UIViewController
    func setTableViewDataSource(dataSource: UITableViewDataSource)
    func reloadData()
    func showMessage(message: String, title: String)
}

class DocumentsViewController: UIViewController, DocumentsViewDelegate{
    weak var documentsTableView: UITableView?
    var presenter: DocumentsPresenterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Загрузка документов"
        setupViews()
    }
    
    func getViewController() -> UIViewController {
        return self
    }
    
    func setTableViewDataSource(dataSource: UITableViewDataSource) {
        DispatchQueue.main.async { [weak self] in
            self?.documentsTableView?.dataSource = dataSource
            self?.documentsTableView?.reloadData()
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.documentsTableView?.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDocuments()
    }
    
    private func setupViews(){
        createTableView()
        setupTableViewConstraints()
    }
    
    func getDocuments(){
        presenter?.loadDocuments()
    }
    
    private func setupTableViewConstraints(){
        guard let documentsTableView = documentsTableView else {
            return
        }
        
        NSLayoutConstraint.activate([
            documentsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            documentsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            documentsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            documentsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    private func createTableView(){
        let tableView = UITableView()
        tableView.alwaysBounceVertical = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(DocumentTableViewCell.self, forCellReuseIdentifier: DocumentTableViewCell.identifire)
        view.addSubview(tableView)
        self.documentsTableView = tableView
    }
}

class DocumentsTableViewDataSource:NSObject, UITableViewDataSource{

    var documents: [Photo] = []
    
    public var loadAction: ((Photo) -> Void)?
    public var getDocImage: ((_ documentId: String, _ completion: @escaping (Data?) -> Void) -> Void)?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DocumentTableViewCell.identifire, for: indexPath)
        let document = documents[indexPath.row]
        
        if let cell = cell as? DocumentTableViewCell{
            cell.setTitle(title: document.name)
            cell.setLoadButtonSettings(title: "Загрузить") { [weak self] in
                self?.loadAction?(document)
            }
            
            if !document.id.isEmpty{
                getDocImage?(document.id, { [weak cell] data in
                    let image = UIImage(data: data ?? Data())
                    cell?.setImage(image: image)
                })
            }
        }
        
        return cell
    }
}
