//
//  PerformersListViewController.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 09.09.2022.
//

import Foundation
import UIKit
class PerformersListViewController: UIViewController{
    weak var performersTableView: UITableView?
    weak var createOrderButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
    }
    
    func setupViews(){
        setupPerformersTableView()
        setupPerformersTableViewConstraints()
        
        setupCreateOrderButton()
        createOrderButton?.setTitle("Оформить заявку", for: .normal)
    }
    
    func setupCreateOrderButton(){
        let button = UIButtonEmassi()
        button.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.titleView = button
        createOrderButton = button
    }
    
    func setupPerformersTableViewConstraints(){
        guard let performersTableView = performersTableView else {
            return
        }
        
        NSLayoutConstraint.activate([
            performersTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            performersTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            performersTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            performersTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    func setupPerformersTableView(){
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(PerformerTableViewCell.self, forCellReuseIdentifier: PerformerTableViewCell.identifire)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        performersTableView = tableView
    }
}

extension PerformersListViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PerformerTableViewCell.identifire, for: indexPath)
        if let cell = cell as? PerformerTableViewCell{
            cell.addCallButton {
                print("call")
            }
            cell.addAcceptButton {
                print("accept")
            }
            cell.addSendMessageButton {
                print("sendMEssage")
            }
            cell.isSelectingEnabled = false
            cell.nameLabel?.text = "gfdgdfgdf"
            cell.photoImageView?.image = UIImage(named: "nophotouser")
            cell.ratingView?.rating = 3
            
            cell.categoryLabel?.text = "gfdgfdgfdg"
            if indexPath.row % 2 == 0 {
                cell.isSelectingEnabled = true
            } else {
                cell.setReviewText(text: "href4wf3dqdwegdwnfJSHFjhwfiwheFIWEhfiweFWefhwieBFwuhefbhwoEBFHWUEBFUWiehbfjkweBFJwebfjhwbEFJHwbehfjbweJFBjwebfejwBFJWBefjwebhref4wf3dqdwegdwnfJSHFjhwfiwheFIWEhfiweFWefhwieBFwuhefbhwoEBFHWUEBFUWiehbfjkweBFJwebfjhwbEFJHwbehfjbweJFBjwebfejwBFJWBefjwebhref4wf3dqdwegdwnfJSHFjhwfiwheFIWEhfiweFWefhwieBFwuhefbhwoEBFHWUEBFUWiehbfjkweBFJwebfjhwbEFJHwbehfjbweJFBjwebfejwBFJWBefjwebhref4wf3dqdwegdwnfJSHFjhwfiwheFIWEhfiweFWefhwieBFwuhefbhwoEBFHWUEBFUWiehbfjkweBFJwebfjhwbEFJHwbehfjbweJFBjwebfejwBFJWBefjwebhref4wf3dqdwegdwnfJSHFjhwfiwheFIWEhfiweFWefhwieBFwuhefbhwoEBFHWUEBFUWiehbfjkweBFJwebfjhwbEFJHwbehfjbweJFBjwebfejwBFJWBefjwebhref4wf3dqdwegdwnfJSHFjhwfiwheFIWEhfiweFWefhwieBFwuhefbhwoEBFHWUEBFUWiehbfjkweBFJwebfjhwbEFJHwbehfjbweJFBjwebfejwBFJWBefjwebhref4wf3dqdwegdwnfJSHFjhwfiwheFIWEhfiweFWefhwieBFwuhefbhwoEBFHWUEBFUWiehbfjkweBFJwebfjhwbEFJHwbehfjbweJFBjwebfejwBFJWBefjweb")
            }
        }
        return cell
    }
    
    
}
