//
//  PerformersCategoriesViewController.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 03.09.2022.
//

import Foundation
import UIKit
protocol PerformersCategoriesViewDelegate: NSObjectProtocol{
    func showMessage(message: String)
    func setDataSource(dataSource: UITableViewDataSource)
    func setTableViewDelegate(delegate: UITableViewDelegate)
    func getViewController() -> UIViewController
}

class PerformersCategoriesViewController: UIViewController, PerformersCategoriesViewDelegate{
    
    weak var tableView: UITableView?
    weak var searchBar: UISearchBar?
    var presenter: PerformersCategoriesPresenterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        getCategories()
    }
    
    func getViewController() -> UIViewController {
        return self
    }
    
    func setDataSource(dataSource: UITableViewDataSource) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView?.dataSource = dataSource
        }
    }
    
    func setTableViewDelegate(delegate: UITableViewDelegate) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView?.delegate = delegate
        }
    }
    
    private func getCategories(){
        presenter?.getCategories(completion: { isSuccess in
            DispatchQueue.main.async { [weak self] in
                self?.tableView?.reloadData()
            }
        })
    }
    
    func setupViews(){
        setupTableView()
        setupSearchBar()
    }
    
    func setupSearchBar(){
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск"
        searchBar.setImage(UIImage(), for: .search, state: .normal)
        searchBar.setImage(UIImage(systemName: "magnifyingglass"), for: .resultsList, state: .normal)
        searchBar.showsSearchResultsButton = true
        searchBar.searchBarStyle = .minimal
    
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.borderStyle = .none
        searchBar.searchTextField.setCornerRadius(value: 12)
        searchBar.searchTextField.setBorder()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(searchBar)
        self.searchBar = searchBar

        navigationItem.titleView = searchBar
//            let bottomConstraint = searchBar.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
//        bottomConstraint.priority = .defaultHigh
//
//        NSLayoutConstraint.activate([
//            searchBar.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10),
//            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
//            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
//            bottomConstraint
//        ])
    }
    
    func setupTableView(){
        let tableView = UITableView()
        tableView.register(PerformersCategoryTableViewCell.self, forCellReuseIdentifier: PerformersCategoryTableViewCell.identifire)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        //tableView.estimatedRowHeight = 44
        
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.alwaysBounceVertical = false
        
        view.addSubview(tableView)
        self.tableView = tableView
        let buttomConstraint = tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        buttomConstraint.priority = .sceneSizeStayPut
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            buttomConstraint
            
        ])
    }
}
