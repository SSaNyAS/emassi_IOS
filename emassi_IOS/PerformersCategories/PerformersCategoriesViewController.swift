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
    var performerCategories: [PerformerCategory] = [
        PerformerCategory(name: "Преподаватели",value: "cat1", imageAddress: "category1"),
        PerformerCategory(name: "Дизайнеры",value: "cat2", imageAddress: "category2"),
        PerformerCategory(name: "Программисты",value: "cat3", imageAddress: "category3"),
        PerformerCategory(name: "Персональные тренера",value: "cat4", imageAddress: "category4"),
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView?.reloadData()
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
            let bottomConstraint = searchBar.bottomAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 30)
        bottomConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            bottomConstraint
        ])
    }
    
    func setupTableView(){
        let tableView = UITableView()
        tableView.register(PerformersCategoryTableViewCell.self, forCellReuseIdentifier: PerformersCategoryTableViewCell.identifire)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.isScrollEnabled = false
        
        view.addSubview(tableView)
        self.tableView = tableView
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
}


extension PerformersCategoriesViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return performerCategories.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PerformersCategoryTableViewCell.identifire, for: indexPath)
        if let cell = cell as? PerformersCategoryTableViewCell{
            let category = performerCategories[indexPath.section]
            cell.setText(text: category.name)
            
            if let image = UIImage(named: category.imageAddress){
                cell.setImage(image: image)
            }
        }
        return cell
    }
    
    
}
