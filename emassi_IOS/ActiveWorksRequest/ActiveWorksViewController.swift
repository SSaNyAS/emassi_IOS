//
//  ActiveWorksViewController.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 04.10.2022.
//

import Foundation
import UIKit

protocol ActiveWorksViewDelegate: AnyObject{
    func getViewController() -> UIViewController
    func setTableViewDataSource(dataSource: UITableViewDataSource)
    func setTableViewDelegate(delegate: UITableViewDelegate)
    func showMessage(message: String, title: String)
    func reloadTableViewData()
    
    func removeBackgroundViews()
    func setGoToRegisterAccountView()
    func setEmptyListView()
    func setTitle(title: String)
}

class ActiveWorksViewController: UIViewController, ActiveWorksViewDelegate{
    weak var worksTableView: UITableView?
    weak var refreshControl: UIRefreshControl?
    weak var emptyListView: UIView?
    weak var goToCreatePerformerAccountView: UIView?
    
    var presenter: ActiveWorksPresenterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presenter?.viewDidLoad()
    }
    
    private func setupViews(){
        view.backgroundColor = .systemBackground
        createWorksTableView()
        setupTableViewConstraints()
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
        removeBackgroundViews()
        presenter?.loadWorks()
    }
    
    func getViewController() -> UIViewController {
        return self
    }
    
    func setTitle(title: String) {
        DispatchQueue.main.async {
            self.title = title
        }
    }
    
    func setTableViewDataSource(dataSource: UITableViewDataSource) {
        DispatchQueue.main.async { [weak self] in
            self?.worksTableView?.dataSource = dataSource
            self?.refreshControl?.endRefreshing()
        }
    }
    
    func setTableViewDelegate(delegate: UITableViewDelegate) {
        DispatchQueue.main.async { [weak self] in
            self?.worksTableView?.delegate = delegate
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
extension ActiveWorksViewController{
    
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
            //goToRegisterButton.addTarget(self, action: #selector(goToRegisterAsPerformer), for: .touchUpInside)
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
    
    private func setupTableViewConstraints(){
        guard let ordersTableView = worksTableView else {
            return
        }
        
        let topToSuperView = ordersTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5)
        
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
        tableView.refreshControl = refreshControl
        self.refreshControl = refreshControl
        tableView.separatorStyle = .none
        tableView.estimatedSectionHeaderHeight = 70
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ActiveWorksHeaderView.self, forHeaderFooterViewReuseIdentifier: ActiveWorksHeaderView.identifire)
        tableView.register(PerformerTableViewCell.self, forCellReuseIdentifier: PerformerTableViewCell.identifire)
        
        view.addSubview(tableView)
        worksTableView = tableView
    }
}

