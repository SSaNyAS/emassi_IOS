//
//  FavoriteViewController.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 12.09.2022.
//

import Foundation
import UIKit
class FavoriteViewController: UIViewController{
    weak var favoritesTableView: UITableView?
    var selectedCell: IndexPath?
    public private(set) var isSelectionMode: Bool = false{
        didSet{
            DispatchQueue.main.async { [weak favoritesTableView, selectedCell] in
                favoritesTableView?.reloadData()
                favoritesTableView?.selectRow(at: selectedCell, animated: true, scrollPosition: .none)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Избранное"
        setupViews()
    }
    
    private func setupViews(){
        createTableView()
        setupTableViewConstraints()
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
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelection = true
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.alwaysBounceVertical = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PerformerTableViewCell.self, forCellReuseIdentifier: PerformerTableViewCell.identifire)
        view.addSubview(tableView)
        self.favoritesTableView = tableView
    }
}

extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    @objc private func longPressOnCell(sender: UILongPressGestureRecognizer){
        if let senderView = sender.view, sender.state == .began{
            print(sender.debugDescription)
            if let performerCell = senderView as? PerformerTableViewCell{
                if !isSelectionMode{
                    selectedCell = favoritesTableView?.indexPath(for: performerCell)
                    isSelectionMode = true
                    performerCell.isSelectingEnabled = true
                } else {
                    favoritesTableView?.indexPathsForSelectedRows?.forEach({favoritesTableView?.deselectRow(at: $0, animated: true)})
                    isSelectionMode = false
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PerformerTableViewCell.identifire, for: indexPath)
        
        
        if let cell = cell as? PerformerTableViewCell{
            cell.nameLabel?.text = "Василенко Игорь Николаевич"
            cell.ratingView?.rating = 4
            cell.categoryLabel?.text = "Репетитор по математике"
            cell.isSelectingEnabled = isSelectionMode
            cell.addSendMessageButton {
                print("send message")
            }
            cell.photoImageView?.image = UIImage(named: "nophotouser")
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

