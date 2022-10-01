//
//  AddressSearchViewController.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 30.09.2022.
//

import UIKit
import CoreLocation

class AddressSearchViewController: UIViewController, UISearchResultsUpdating{
    weak var tableView: UITableView!
    lazy var searchController =  UISearchController()
    let cellIdentifire = "cellAddress"
    let geoCoder: CLGeocoder = CLGeocoder()
    public var didSelectAddressAction: ((Address)-> Void)?
    lazy var locationManager: LocationManager? = {
        let locationManager = LocationManager()
        return locationManager
    }()
    
    var addressList: [Address] = []{
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    public var showGetMyLocationRow = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Выбор адреса"
        
        searchController.searchBar.textContentType = .fullStreetAddress
        searchController.searchResultsUpdater =  self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        setupViews()
        updateSearchResults(for: searchController)
        searchController.showsSearchResultsController = true
        searchController.isActive = true
    }
    
    @objc private func goBack(){
        dismiss(animated: true)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if navigationController == nil {
            super.dismiss(animated: flag, completion: completion)
        } else {
            navigationController?.dismiss(animated: flag, completion: completion)
        }
    }
    
    func getMyLocation(completion: ((Address?) -> Void)? = nil ){
        guard let locationManager = locationManager else {
            return
        }
        locationManager.startUpdateLocations()
        locationManager.didCompleteGetLocation = { [weak self] location in
            self?.geocodeFromLocation(location: location) { address in
                completion?(address)
            }
            self?.locationManager = nil
        }
        locationManager.didFailGetLocation = { [weak self] error in
            completion?(nil)
            self?.showMessage(message: "Ошибка при получении геопозиции", title: "")
            self?.locationManager = nil
        }
    }
    
    func geocodeFromLocation(location: CLLocation, completion: ((Address?) -> Void)? = nil ){
        geoCoder.reverseGeocodeLocation(location) { places, error in
            guard let places = places, error == nil else {
                return
            }
            if places.count == 1 {
                let address = Address(place: places.first!)
                completion?(address)
                return
            } else {
                self.addressList = places.map({
                    Address(place: $0)
                })
            }
            completion?(nil)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        geoCoder.cancelGeocode()
        geoCoder.geocodeAddressString(searchText ?? "") { places, error in
            guard error == nil else {
                self.addressList = []
                return
            }
            self.addressList = places?.compactMap({ place in
                let address = Address(place: place)
                return address
            }) ?? []
            print (self.addressList)
        }
    }
    
    
    func setupViews(){
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self,forCellReuseIdentifier: cellIdentifire)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        self.tableView = tableView
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

}

extension AddressSearchViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if showGetMyLocationRow && indexPath.row == 0 {
            getMyLocation { [weak self] address in
                if let address = address{
                    self?.didSelectAddressAction?(address)
                    self?.dismiss(animated: true)
                }
            }
            return
        }
        let rowIndex = showGetMyLocationRow ? indexPath.row - 1 : indexPath.row
        let selectedAddress = addressList[rowIndex]
        didSelectAddressAction?(selectedAddress)
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showGetMyLocationRow {
            return addressList.count + 1
        }
        return addressList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifire, for: indexPath)
        let rowIndex = showGetMyLocationRow ? indexPath.row - 1 : indexPath.row
        if showGetMyLocationRow && indexPath.row == 0 {
            cell.textLabel?.text = "Получить мою геопозицию"
            cell.imageView?.image = UIImage(systemName: "location.fill")?.withTintColor(.baseAppColor, renderingMode: .alwaysOriginal)
        } else {
            let currentAddress = addressList[rowIndex]
            cell.textLabel?.text = currentAddress.commonString
            cell.textLabel?.numberOfLines = 0
        }
        return cell
    }
}
