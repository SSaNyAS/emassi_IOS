//
//  MenuViewController.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 06.09.2022.
//

import Foundation
import UIKit
class MenuViewController: UIViewController{
    weak var profileImageView: UIImageView?
    weak var nameLabel: UILabel?
    weak var menuTableView: UITableView?
    weak var menuNavigationController: UINavigationController?
    weak var router: RouterDelegate? {
        didSet{
            setCommands()
        }
    }
    
    var commands: [MenuAction] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        setCommands()
        setupViews()
    }
    
    func setupViews(){
        createImageView(in: view)
        createNameLabel(in: view)
        createMenuTableView(in: view)
        
        setupImageViewConstraints(to: view)
        setupNameLabelConstraints(to: view)
        setupMenuTableViewConstraints(to: view)
    }
    
    @objc func didPressOnProfileImage(){
        if let currentVC = menuNavigationController?.topViewController{
            router?.goToViewController(from: currentVC, to: .performerProfile, presentationMode: .push)
        }
    }
    
    @MainActor
    func setCommands(){
        commands = [
            .init(title: "Категории", image: "rectangle.stack.fill"){ [weak menuNavigationController, weak router] in
                print("Категории")
                if let currentVC = menuNavigationController?.topViewController{
                    router?.goToViewController(from: currentVC, to: .categories, presentationMode: .popToRoot)
                }
            },
            .init(title: "Активные заявки", image: "clock.badge.checkmark.fill"){ [weak menuNavigationController, weak router] in
                if let currentVC = menuNavigationController?.topViewController{
                    router?.goToViewController(from: currentVC, to: .activeWorks, presentationMode: .push)
                }
            },
            .init(title: "Лента заявок", image: "clock.badge.checkmark.fill"){ [weak menuNavigationController, weak router] in
                if let currentVC = menuNavigationController?.topViewController{
                    router?.goToViewController(from: currentVC, to: .ordersList, presentationMode: .push)
                }
            },
            .init(title: "Работа", image: "clock.badge.checkmark.fill"){ [weak menuNavigationController, weak router] in
                if let currentVC = menuNavigationController?.topViewController{
                    router?.goToViewController(from: currentVC, to: .myWorks, presentationMode: .push)
                }
            },
            .init(title: "Чат", image: "message.fill"){ [weak menuNavigationController, weak router] in
                if let currentVC = menuNavigationController?.topViewController{
                    router?.goToViewController(from: currentVC, to: .orderInfo(""), presentationMode: .push)
                }
            },
            .init(title: "Отзыв", image: "star.fill"){ [weak menuNavigationController, weak router] in
                if let currentVC = menuNavigationController?.topViewController{
                    router?.goToViewController(from: currentVC, to: .feedback(""), presentationMode: .push)
                }
            },
            .init(title: "Создать заявку", image: "star.fill"){ [weak menuNavigationController, weak router] in
                if let currentVC = menuNavigationController?.topViewController{
                    router?.goToViewController(from: currentVC, to: .createRequest("",nil), presentationMode: .push)
                }
            },
            .init(title: "Избранное", image: "star.fill"){ [weak menuNavigationController, weak router] in
                if let currentVC = menuNavigationController?.topViewController{
                    router?.goToViewController(from: currentVC, to: .favorites, presentationMode: .push)
                }
            },
            .init(title: "Архив заявок", image: "folder.fill"){
                
            },
            .init(title: "Профиль", image: "person.fill"){ [weak menuNavigationController, weak router] in
                if let currentVC = menuNavigationController?.topViewController{
                    router?.goToViewController(from: currentVC, to: .performerInfo(""), presentationMode: .push)
                }
            },
            .init(title: "Регистрация специалиста", image: "person.fill.badge.plus"){
                
            },
            .init(title: "Помощь", image: "questionmark.circle"){
                
            },
            .init(title: "Документы", image: "gear"){ [weak menuNavigationController, weak router] in
                if let currentVC = menuNavigationController?.topViewController{
                    router?.goToViewController(from: currentVC, to: .documents, presentationMode: .push)
                }
            },
            .init(title: "Настройки", image: "gear"){ [weak menuNavigationController, weak router] in
                if let currentVC = menuNavigationController?.topViewController{
                    router?.goToViewController(from: currentVC, to: .settings, presentationMode: .push)
                }
            },
        ]
        menuTableView?.reloadData()
    }
    
    func setupMenuTableViewConstraints(to view: UIView){
        guard let menuTableView = menuTableView, let profileImageView = profileImageView else {
            return
        }
        
        NSLayoutConstraint.activate([
            menuTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            menuTableView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 30),
            menuTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            menuTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    func setupNameLabelConstraints(to view: UIView){
        guard let nameLabel = nameLabel, let profileImageView = profileImageView else {
            return
        }
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    func setupImageViewConstraints(to view: UIView){
        guard let profileImageView = profileImageView else {
            return
        }
        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor, multiplier: 1.2),
            profileImageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.4),
        ])
    }
    
    func createMenuTableView(in view: UIView){
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorInset = .zero
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        menuTableView = tableView
    }
    func createNameLabel(in view: UIView){
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        nameLabel = label
    }
    
    func createImageView(in view: UIView){
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = .noPhotoUser
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.setCornerRadius(value: 12)
        imageView.setBorder()
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didPressOnProfileImage))
        imageView.addGestureRecognizer(tapGesture)
        
        view.addSubview(imageView)
        profileImageView = imageView
    }
}


extension MenuViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commands.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        commands[indexPath.row].action()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.contentMode = .scaleAspectFit
        cell.backgroundColor = .clear
        let currentCommand = commands[indexPath.row]
        if #available(iOS 14.0, *) {
            var content = UIListContentConfiguration.valueCell()
            content.imageToTextPadding = 5
            content.text = currentCommand.title
            if currentCommand.image.isEmpty == false{
                content.image = UIImage(systemName: currentCommand.image)
            }
            content.imageProperties.tintColor = .lightGray
            content.textToSecondaryTextHorizontalPadding = .zero
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = currentCommand.title
            if currentCommand.image.isEmpty == false{
                cell.imageView?.image = UIImage(systemName: currentCommand.image)
            }
            cell.imageView?.tintColor = .lightGray
        }
        
        if indexPath.row == commands.count - 1{
            cell.separatorInset = .init(top: 0, left: tableView.frame.width, bottom: 0, right: 0)
        }
        
        return cell
    }
    
    
}
