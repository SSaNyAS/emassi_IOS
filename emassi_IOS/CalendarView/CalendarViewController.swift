//
//  CalendarViewController.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 16.10.2022.
//

import UIKit

protocol CalendarViewDelegate: AnyObject{
    func reloadData()
    func setTableViewDataSource(dataSource: UITableViewDataSource)
    func reloadTableViewData()
    func setEmptyListView()
    func removeBackgroundViews()
}

class CalendarViewController: UIViewController, CalendarViewDelegate{
    weak var tableView: UITableView!
    weak var refreshControl: UIRefreshControl!
    var presenter: CalendarPresenterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Календарь"
        setupViews()
        presenter?.viewDidLoad()
    }
    
    @objc func reloadData() {
        refreshControl.beginRefreshing()
        presenter?.reloadData()
    }
    
    func setTableViewDataSource(dataSource: UITableViewDataSource) {
        DispatchQueue.main.async {
            self.tableView.dataSource = dataSource
        }
    }
    
    func reloadTableViewData(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func setEmptyListView() {
        
    }
    
    func removeBackgroundViews() {
        
    }
}

// MARK: Setup views
extension CalendarViewController{
    private func setupViews(){
        createTableView()
        setupTableViewConstraints()
    }
    
    private func setupTableViewConstraints(){
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
    }
    
    private func createTableView(){
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(CalendarTableViewCell.self, forCellReuseIdentifier: CalendarTableViewCell.identifire)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        view.addSubview(tableView)
        self.tableView = tableView
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        refreshControl.attributedTitle = .init(string: "Обновление...", attributes: [.foregroundColor: UIColor.placeholderText])
        tableView.refreshControl = refreshControl
        self.refreshControl = refreshControl
    }
}
