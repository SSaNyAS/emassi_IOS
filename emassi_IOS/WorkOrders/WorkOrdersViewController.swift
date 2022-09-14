//
//  WorkOrdersViewController.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 13.09.2022.
//

import Foundation
import UIKit
class WorkOrdersViewController: UIViewController{
    weak var ordersTableView: UITableView?
    weak var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews(){
        view.backgroundColor = .white
        createOrdersTableView()
        setupTableViewConstraints()
        
    }
    
    private func setupTableViewConstraints(){
        guard let ordersTableView = ordersTableView else {
            return
        }
        NSLayoutConstraint.activate([
            ordersTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            ordersTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            ordersTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            ordersTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
    }
    
    private func createOrdersTableView(){
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(WorkOrderTableViewCell.self, forCellReuseIdentifier: WorkOrderTableViewCell.identifire)
        
        view.addSubview(tableView)
        ordersTableView = tableView
    }
}

extension WorkOrdersViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WorkOrderTableViewCell.identifire, for: indexPath)
        if let cell = cell as? WorkOrderTableViewCell{
            cell.orderTypeLabel?.text = "Вызов"
            cell.categoryLabel?.text = "Репетитор по математике"
            cell.dateLabel?.text = Date().description(with: .current)
            cell.addressLabel?.text = "г. Москва ул Слоновая д 12"
            
            cell.createButton(title: "Внести в календарь") {
                print("addToCalendar")
            }
            cell.createButton(title: "Написать") {
                print("sendmessage")
            }
            
        }
        return cell
    }
}
