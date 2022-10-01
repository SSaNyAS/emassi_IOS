//
//  SettingsViewController.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 14.09.2022.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController{
    weak var settingsTableView: UITableView?
    weak var router: RouterDelegate?
    
    var settings: [MenuAction] = [
        .init(title: "Уведомления", image: "", action: {
            
        }),
        .init(title: "FAQ", image: "", action: {
            if let url = URL(string: EmassiApi.faq){
                if UIApplication.shared.canOpenURL(url){
                    UIApplication.shared.open(url)
                }
               
            }
        }),
        .init(title: "Пользовательское соглашение", image: "", action: {
            if let url = URL(string: EmassiApi.privacyPolicy){
                if UIApplication.shared.canOpenURL(url){
                    UIApplication.shared.open(url)
                }
               
            }
        }),
        .init(title: "Выйти из профиля", image: "", action: {
            SessionConfiguration.Logout()
        })
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews(){
        view.backgroundColor = .white
        createOrdersTableView()
        setupTableViewConstraints()
        
    }
    
    private func setupTableViewConstraints(){
        guard let settingsTableView = settingsTableView else {
            return
        }
        NSLayoutConstraint.activate([
            settingsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            settingsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            settingsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            settingsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
    }
    
    private func createOrdersTableView(){
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifire)
        
        view.addSubview(tableView)
        settingsTableView = tableView
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let setting = settings[indexPath.row]
        setting.action()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifire, for: indexPath)
        if let cell = cell as? SettingTableViewCell{
            let setting = settings[indexPath.row]
            cell.settingNameLabel?.text = setting.title
        }
        return cell
    }
}
