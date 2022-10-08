//
//  FavoriteViewController.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 12.09.2022.
//

import Foundation
import UIKit

protocol FavoriteViewDelegate: AnyObject{
    func setTableViewDataSource(dataSource: UITableViewDataSource)
    func setTableViewDelegate(delegate: UITableViewDelegate)
    func reloadTableViewData()
    func setEmptyListView()
    func removeBackgroundViews()
}

class FavoriteViewController: UIViewController, FavoriteViewDelegate{
    weak var favoritesTableView: UITableView?
    weak var refreshControl: UIRefreshControl?
    weak var emptyListView: UIView?
    
    var presenter: FavoritePresenterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Избранное"
        setupViews()
        presenter?.viewDidLoad()
    }
    
    
    @objc func reloadData(){
        refreshControl?.beginRefreshing()
        removeBackgroundViews()
        presenter?.getFavorites()
    }
    
    func setTableViewDataSource(dataSource: UITableViewDataSource) {
        DispatchQueue.main.async {
            self.favoritesTableView?.dataSource = dataSource
        }
    }
    
    func setTableViewDelegate(delegate: UITableViewDelegate) {
        DispatchQueue.main.async {
            self.favoritesTableView?.delegate = delegate
        }
    }
    
    func reloadTableViewData() {
        DispatchQueue.main.async {
            self.refreshControl?.beginRefreshing()
            self.favoritesTableView?.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    func setEmptyListView() {
        DispatchQueue.main.async {
            self.createEmptyListView(isShow: true)
        }
    }
    
    func removeBackgroundViews(){
        DispatchQueue.main.async {
            self.createEmptyListView(isShow: false)
        }
    }
}

//MARK: CreateViews
extension FavoriteViewController{
    private func setupViews(){
        createTableView()
        setupTableViewConstraints()
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
            favoritesTableView?.backgroundView = view
        } else {
                emptyListView?.removeFromSuperview()
                emptyListView = nil
                favoritesTableView?.backgroundView = nil
        }
    }
    
    private func setupTableViewConstraints(){
        guard let favoritesTableView = favoritesTableView else {
            return
        }
        
        NSLayoutConstraint.activate([
            favoritesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            favoritesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            favoritesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            favoritesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    private func createTableView(){
        let tableView = UITableView()
        tableView.allowsMultipleSelection = true
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.alwaysBounceVertical = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PerformerTableViewCell.self, forCellReuseIdentifier: PerformerTableViewCell.identifire)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        refreshControl.attributedTitle = .init(string: "Обновление...",attributes: [.foregroundColor: UIColor.placeholderText])
        tableView.refreshControl = refreshControl
        self.refreshControl = refreshControl
        view.addSubview(tableView)
        self.favoritesTableView = tableView
    }
}

class FavoriteTableViewDataUIWorker:NSObject, UITableViewDataSource, UITableViewDelegate{
    var performers: [PerformerInfo] = []
    var getCategoryNameAction: ((_ categoryId: String, @escaping (String?) -> Void) -> Void)?
    var getSuperCategoryNameAction: ((_ categoryId: String, @escaping (String?) -> Void) -> Void)?
    var getPerformerPhoto: ((_ performerId: String, @escaping (Data?) ->Void )->Void)?
    
    weak var tableView: UITableView?
    public private(set) var isSelectionMode: Bool = false{
        didSet{
            DispatchQueue.main.async { [weak tableView, selectedCell] in
                tableView?.reloadData()
                tableView?.selectRow(at: selectedCell, animated: true, scrollPosition: .none)
            }
        }
    }
    var selectedCell: IndexPath?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return performers.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.tableView = tableView
        return 1
    }
    
    @objc private func longPressOnCell(sender: UILongPressGestureRecognizer){
        if let senderView = sender.view, sender.state == .began{
            print(sender.debugDescription)
            if let performerCell = senderView as? PerformerTableViewCell{
                if !isSelectionMode{
                    selectedCell = tableView?.indexPath(for: performerCell)
                    isSelectionMode = true
                    performerCell.isSelectingEnabled = true
                } else {
                    tableView?.indexPathsForSelectedRows?.forEach({tableView?.deselectRow(at: $0, animated: true)})
                    isSelectionMode = false
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PerformerTableViewCell.identifire, for: indexPath)
        
        if let cell = cell as? PerformerTableViewCell{
            let performer = performers[indexPath.row]
            
//            getCategoryNameAction?(performer) {[weak self,weak categoryLabel = cell.categoryLabel] categoryName in
//                
//                if let categoryName = categoryName{
//                    DispatchQueue.main.async {
//                        categoryLabel?.text = categoryName + "\r\n\(work.startDate.formattedAsDateTime())"
//                    }
//                } else {
//                    self?.getSuperCategoryNameAction?(work.category.level1) { [weak categoryLabel] superCategoryName in
//                        if let superCategoryName = superCategoryName{
//                            DispatchQueue.main.async {
//                                categoryLabel?.text = superCategoryName + "\r\n\(work.startDate.formattedAsDateTime())"
//                            }
//                        } else {
//                            DispatchQueue.main.async {
//                                categoryLabel?.text = work.startDate.formattedAsDateTime()
//                            }
//                        }
//                    }
//                }
//            }
            
            cell.nameLabel?.text = performer.username.common
            cell.ratingView?.rating = performer.rating5
            cell.isSelectingEnabled = isSelectionMode
            cell.addSendMessageButton {
                print("send message")
            }
            getPerformerPhoto?(performer.id){ [weak photoImageView = cell.photoImageView] imageData in
                DispatchQueue.main.async {
                    photoImageView?.image = UIImage(data: imageData ?? Data()) ?? .noPhotoUser
                }
            }
            cell.addCallButton { [weak categoryLabel = cell.categoryLabel] in
                print("call to \(categoryLabel?.text ?? "")")
            }
            cell.isUserInteractionEnabled = true
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressOnCell(sender:)))
            longPressGesture.minimumPressDuration = 0.7
            longPressGesture.numberOfTouchesRequired = 1
            longPressGesture.name = "\(indexPath.row)"
            cell.addGestureRecognizer(longPressGesture)
        }
        
        return cell
    }
}

