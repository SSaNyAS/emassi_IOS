//
//  DocumentsViewController.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 12.09.2022.
//

import Foundation
import UIKit
class DocumentsViewController: UIViewController{
    weak var documentsTableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Загрузка документов"
        setupViews()
    }
    
    private func setupViews(){
        createTableView()
        setupTableViewConstraints()
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
        tableView.dataSource = self
        tableView.alwaysBounceVertical = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(DocumentTableViewCell.self, forCellReuseIdentifier: DocumentTableViewCell.identifire)
        view.addSubview(tableView)
        self.documentsTableView = tableView
    }
}

extension DocumentsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DocumentTableViewCell.identifire, for: indexPath)
        
        if let cell = cell as? DocumentTableViewCell{
            cell.setTitle(title: "Удостоверение личности")
            cell.setLoadButtonSettings(title: "Загрузить") {
                print("documentLoading")
            }
        }
        
        return cell
    }
}
