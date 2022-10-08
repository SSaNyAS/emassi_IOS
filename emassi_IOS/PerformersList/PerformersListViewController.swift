//
//  PerformersListViewController.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 09.09.2022.
//

import Foundation
import UIKit

protocol PerformersListViewDelegate: NSObjectProtocol{
    func getViewController() -> UIViewController
    func showMessage(message: String, title: String)
    func updateTableView()
    func setTableViewDataSource(dataSource: UITableViewDataSource)
    func setTableViewDelegate(delegate: UITableViewDelegate)
}

class PerformersListViewController: UIViewController, PerformersListViewDelegate{
    weak var performersTableView: UITableView?
    weak var createOrderButton: UIButton?
    weak var noItemsView: UIView?
    weak var refreshControl: UIRefreshControl?
    
    var presenter: PerformersListPresenterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
    }
    
    func getViewController() -> UIViewController {
        return self
    }
    
    func setTableViewDelegate(delegate: UITableViewDelegate) {
        DispatchQueue.main.async { [weak self] in
            self?.performersTableView?.delegate = delegate
        }
    }
    
    func setTableViewDataSource(dataSource: UITableViewDataSource) {
        DispatchQueue.main.async { [weak self] in
            self?.performersTableView?.dataSource = dataSource
        }
    }
    
    func setupViews(){
        setupPerformersTableView()
        setupRefreshControl()
        setupPerformersTableViewConstraints()

        setupCreateOrderButton()
        createOrderButton?.setTitle("Оформить заявку", for: .normal)
        createOrderButton?.addTarget(self, action: #selector(createOrderButtonClick), for: .touchUpInside)
    }
    
    @objc private func createOrderButtonClick(){
        presenter?.createOrder()
    }
    
    @objc private func updateData(){
        refreshControl?.beginRefreshing()
        setNoItemsView(isShow: false)
        presenter?.loadPerformers(completion: {[weak self] _ in
            self?.updateTableView()
        })
    }
    
    func updateTableView(){
        DispatchQueue.main.async { [weak self] in
            self?.performersTableView?.reloadData()
            let isShow = self?.performersTableView?.numberOfRows(inSection: 0) == 0
            self?.setNoItemsView(isShow: isShow)
            self?.refreshControl?.endRefreshing()
        }
    }
    
    func setNoItemsView(isShow: Bool = true){
        if isShow{
            let view = UILabel()
            view.font = .systemFont(ofSize: 16)
            view.textAlignment = .center
            view.numberOfLines = 0
            view.textColor = .placeholderText
            view.text = "Поиск не дал результатов"
            noItemsView = view
            performersTableView?.backgroundView = noItemsView
        } else {
            noItemsView?.removeFromSuperview()
            noItemsView = nil
            performersTableView?.backgroundView = nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
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
    
    // вызывать после создания таблицы
    func setupRefreshControl(){
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = .init(string: "Обновление...",attributes: [.foregroundColor: UIColor.placeholderText])
        refreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
        performersTableView?.refreshControl = refreshControl
        self.refreshControl = refreshControl
    }
    
    func setupPerformersTableView(){
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(PerformerTableViewCell.self, forCellReuseIdentifier: PerformerTableViewCell.identifire)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        performersTableView = tableView
    }
}
