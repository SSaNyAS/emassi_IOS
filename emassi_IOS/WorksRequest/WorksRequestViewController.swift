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
    func reloadTableViewData()
    
    func removeBackgroundViews()
    func setGoToRegisterAccountView()
    func setEmptyListView()
}

class WorksRequestViewController: UIViewController, WorksRequestViewDelegate{
    weak var worksTableView: UITableView?
    weak var datePicker: UIDatePicker?
    weak var refreshControl: UIRefreshControl?
    weak var emptyListView: UIView?
    weak var goToCreatePerformerAccountView: UIView?
    
    var presenter: WorksRequestPresenterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Работа"
        setupViews()
        presenter?.viewDidLoad(date: datePicker?.date)
    }
    
    private func setupViews(){
        view.backgroundColor = .white
        createWorksTableView()
        createDataPicker()
        
        setupTableViewConstraints()
        setupDatePickerConstraints()
    }
    
    func removeBackgroundViews(){
        DispatchQueue.main.async {
            self.createEmptyListView(isShow: false)
        }
    }
    
    func setGoToRegisterAccountView(){
        DispatchQueue.main.async {
            self.createGoToCreatePerformerAccountView(isShow: true)
        }
    }
    
    func setEmptyListView(){
        DispatchQueue.main.async {
            self.createEmptyListView(isShow: true)
        }
    }
    
    @objc func reloadData(){
        refreshControl?.beginRefreshing()
        if goToCreatePerformerAccountView == nil{
            presenter?.getAllWorks(date: datePicker?.date)
            removeBackgroundViews()
        } else {
            refreshControl?.endRefreshing()
        }
    }
    
    @objc func datePickerValueChanged(){
        DispatchQueue.main.async {
            self.presentedViewController?.dismiss(animated: true)
            self.reloadData()
        }
    }
    
    @objc private func goToRegisterAsPerformer(){
        presenter?.goToRegisterAsPerformer()
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
    
    func reloadTableViewData(){
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl?.beginRefreshing()
            self?.worksTableView?.reloadData()
            self?.refreshControl?.endRefreshing()
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
    
    private func createEmptyListView(isShow: Bool = false){
        if isShow{
            let view = UILabel()
            view.font = .systemFont(ofSize: 16)
            view.textAlignment = .center
            view.numberOfLines = 0
            view.textColor = .placeholderText
            view.text = "Поиск не дал результатов"
            emptyListView = view
            worksTableView?.backgroundView = view
        } else {
                emptyListView?.removeFromSuperview()
                emptyListView = nil
                goToCreatePerformerAccountView?.removeFromSuperview()
                goToCreatePerformerAccountView = nil
                worksTableView?.backgroundView = nil
        }
    }
    
    private func createGoToCreatePerformerAccountView(isShow: Bool = false){
        if isShow{
            let view = UIView()
            let label = UILabel()
            label.font = .systemFont(ofSize: 16)
            label.textAlignment = .center
            label.numberOfLines = 0
            label.textColor = .placeholderText
            label.text = "Для просмотра необходимо зарегистрироваться как исполнитель"
            label.translatesAutoresizingMaskIntoConstraints = false
            let goToRegisterButton = UIButtonEmassi()
            goToRegisterButton.setTitle("Зарегистрироваться", for: .normal)
            goToRegisterButton.addTarget(self, action: #selector(goToRegisterAsPerformer), for: .touchUpInside)
            goToRegisterButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
            view.addSubview(goToRegisterButton)
            
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 10),
                label.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
                label.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -10),
                
                goToRegisterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                goToRegisterButton.topAnchor.constraint(equalTo: label.bottomAnchor,constant: 10),
                goToRegisterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                goToRegisterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
            goToCreatePerformerAccountView = view
            worksTableView?.backgroundView = view
        } else {
            emptyListView?.removeFromSuperview()
            emptyListView = nil
            goToCreatePerformerAccountView?.removeFromSuperview()
            goToCreatePerformerAccountView = nil
            worksTableView?.backgroundView = nil
        }
    }
    
    private func createDataPicker(){
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
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
        topToSuperView.priority = .defaultHigh - 1
        
        NSLayoutConstraint.activate([
            ordersTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            topToSuperView,
            ordersTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            ordersTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
    }
    
    private func createWorksTableView(){
        let tableView = UITableView()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        refreshControl.attributedTitle = .init(string: "Обновление...", attributes: [.foregroundColor: UIColor.placeholderText])
        tableView.refreshControl = refreshControl
        self.refreshControl = refreshControl
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(WorksRequestTableViewCell.self, forCellReuseIdentifier: WorksRequestTableViewCell.identifire)
        
        view.addSubview(tableView)
        worksTableView = tableView
    }
}

