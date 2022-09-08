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
    var performersCategoriesDataSourceDelegate: PerformersCategoriesTableViewDataSourceDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Category"
        navigationItem.largeTitleDisplayMode = .always
        
        let dataSource = PerformersCategoriesTableViewDataSourceDelegate()
        dataSource.performersCategories = [
            PerformersCategory(name: "Преподаватели",value: "cat1", imageAddress: "category1", subCategories: [
                .init(name: "Репетитор по математике", value: "mathRepetitor"),
                .init(name: "Репетитор по истории", value: "historyRepetitor"),
                .init(name: "Репетитор по Географии", value: "geographyRepetitor"),
            ]),
            
            PerformersCategory(name: "Дизайнеры",value: "cat2", imageAddress: "category2",subCategories: [
                .init(name: "Графический дизайнер", value: "graphicsDesigner"),
                .init(name: "Дизайнер интерьеров", value: "interierDesigner")
            ]),
            
            PerformersCategory(name: "Программисты",value: "cat3", imageAddress: "category3", subCategories: [
                .init(name: "Front-end разработчик", value: "frontEndDeveloper"),
                .init(name: "Back-end Developer", value: "backEndDeveloper"),
                .init(name: "Full-stack разработчик", value: "fullStackDeveloper"),
                .init(name: "Game Developer", value: "gameDeveloper"),
                .init(name: "Android разработчик", value: "androidDeveloper"),
                .init(name: "IOS разработчик", value: "iosDeveloper"),
                .init(name: "IOS разработчик", value: "iosDeveloper"),
                .init(name: "IOS разработчик", value: "iosDeveloper"),
                .init(name: "IOS разработчик", value: "iosDeveloper"),
                .init(name: "IOS разработчик", value: "iosDeveloper"),
                .init(name: "IOS разработчик", value: "iosDeveloper"),
                .init(name: "IOS разработчик", value: "iosDeveloper"),
                .init(name: "IOS разработчик", value: "iosDeveloper"),
                .init(name: "IOS разработчик", value: "iosDeveloper"),
                .init(name: "IOS разработчик", value: "iosDeveloper"),
                .init(name: "IOS разработчик", value: "iosDeveloper"),
                .init(name: "IOS разработчик", value: "iosDeveloper"),
            ]),
            
            PerformersCategory(name: "Персональные тренера",value: "cat4", imageAddress: "category4", subCategories: [
                .init(name: "Персональный тренер", value: "personalTrainer")
            ]),
        ]
        self.performersCategoriesDataSourceDelegate = dataSource
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
        
        tableView.dataSource = performersCategoriesDataSourceDelegate
        tableView.delegate = performersCategoriesDataSourceDelegate
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
