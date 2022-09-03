//
//  PerformersCategoriesViewController.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 03.09.2022.
//

import Foundation
import UIKit
class PerformersCategoriesViewController: UIViewController{
    weak var tableView: UITableView?
    weak var searchBar: UISearchBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
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
        
        guard let tableView = tableView else {
            return
        }

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            searchBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 30)
        ])
    }
    func setupTableView(){
        let tableView = UITableView()
        tableView.backgroundColor = .orange
        tableView.register(PerformersCategoryTableViewCell.self, forCellReuseIdentifier: PerformersCategoryTableViewCell.identifire)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        self.tableView = tableView
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
}
