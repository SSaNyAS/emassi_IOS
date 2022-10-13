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
    func reloadTableViewData()
}

class PerformersCategoriesViewController: UIViewController, PerformersCategoriesViewDelegate{
    weak var refreshControl: UIRefreshControl?
    weak var tableView: UITableView?
    weak var searchBar: UISearchBar?
    var presenter: PerformersCategoriesPresenterDelegate?
    public var isVisible: Bool = false{
        didSet{
            if isLazyReload {
                reloadTableViewData()
            }
        }
    }
    private var isLazyReload: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isVisible = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isVisible = false
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
    
    func reloadTableViewData() {
        DispatchQueue.main.async { [weak self] in
            if self?.isVisible == true{
//                let sections = IndexSet(integersIn: 0..<(self?.tableView?.numberOfSections ?? 0))
//                self?.tableView?.reloadSections(sections, with: .automatic)
                self?.tableView?.reloadData()
                self?.refreshControl?.endRefreshing()
                self?.isLazyReload = false
            } else {
                self?.isLazyReload = true
            }
        }
    }
    
    @objc func reloadData(){
        refreshControl?.beginRefreshing()
        presenter?.getCategories()
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
    
        searchBar.searchTextField.backgroundColor = .systemBackground
        searchBar.searchTextField.borderStyle = .none
        searchBar.searchTextField.setCornerRadius(value: 12)
        searchBar.searchTextField.setBorder()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        
        view.addSubview(searchBar)
        self.searchBar = searchBar

        navigationItem.titleView = searchBar
    }
    
    func setupTableView(){
        let tableView = UITableView()
        tableView.register(PerformersCategoryTableViewCell.self, forCellReuseIdentifier: PerformersCategoryTableViewCell.identifire)
        tableView.register(UITableViewCell.self,forCellReuseIdentifier: PerformersCategoriesTableViewDataSourceDelegate.subCategoryCellIdentifire)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.alwaysBounceVertical = false
        tableView.contentInset = .init(top: 0, left: 0, bottom: 30, right: 0)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        refreshControl.attributedTitle = .init(string: "Обновление...",attributes: [.foregroundColor: UIColor.placeholderText])
        tableView.refreshControl = refreshControl
        self.refreshControl = refreshControl
        view.addSubview(tableView)
        self.tableView = tableView
        let buttomConstraint = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        buttomConstraint.priority = .required
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            buttomConstraint
            
        ])
    }
}

extension PerformersCategoriesViewController: UISearchBarDelegate{
    @objc private func searchWithThrottle(searchText: String){
        presenter?.didChangeSearchText(searchText: searchText)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(searchWithThrottle(searchText:)),
                                                   object: searchText)

        perform(#selector(searchWithThrottle(searchText:)),
                    with: searchText, afterDelay: 0.5)
        
    }
}
