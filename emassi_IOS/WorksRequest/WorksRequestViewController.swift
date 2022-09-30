//
//  WorksRequestViewController.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 13.09.2022.
//

import Foundation
import UIKit

protocol WorksRequestViewDelegate: AnyObject{
    func getViewController() -> UIViewController
    func setTableViewDataSource(dataSource: UITableViewDataSource)
    func showMessage(message: String, title: String)
    func setDate(date: Date)
    func reloadData()
}

class WorksRequestViewController: UIViewController, WorksRequestViewDelegate{
    weak var worksTableView: UITableView?
    weak var datePicker: UIDatePicker?
    var presenter: WorksRequestPresenterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presenter?.viewDidLoad()
    }
    
    private func setupViews(){
        view.backgroundColor = .white
        createWorksTableView()
        createDataPicker()
        
        setupTableViewConstraints()
        setupDatePickerConstraints()
    }
    
    func getViewController() -> UIViewController {
        return self
    }
    
    func setDate(date: Date) {
        DispatchQueue.main.async { [weak self] in
            self?.datePicker?.date = date
        }
    }
    
    func setTableViewDataSource(dataSource: UITableViewDataSource) {
        DispatchQueue.main.async { [weak self] in
            self?.worksTableView?.dataSource = dataSource
        }
    }
    
    func reloadData(){
        DispatchQueue.main.async { [weak self] in
            self?.worksTableView?.reloadData()
        }
    }
}



// MARK: Create Views
extension WorksRequestViewController{
    
    private func setupDatePickerConstraints(){
        guard let datePicker = datePicker else {return}
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            datePicker.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            datePicker.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            datePicker.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        ])
    }
    
    private func createDataPicker(){
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(datePicker)
        self.datePicker = datePicker
    }
    
    private func setupTableViewConstraints(){
        guard let ordersTableView = worksTableView else {
            return
        }
        
        if let datePicker = datePicker{
            let constraint = ordersTableView.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 5)
            constraint.priority = .required
            constraint.isActive = true
        }
        
        let topToSuperView = ordersTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5)
        topToSuperView.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            ordersTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            topToSuperView,
            ordersTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            ordersTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
    }
    
    private func createWorksTableView(){
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(WorksRequestTableViewCell.self, forCellReuseIdentifier: WorksRequestTableViewCell.identifire)
        
        view.addSubview(tableView)
        worksTableView = tableView
    }
}

