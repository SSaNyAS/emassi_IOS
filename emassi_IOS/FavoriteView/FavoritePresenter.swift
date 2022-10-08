//
//  FavoritePresenter.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 09.10.2022.
//

import Foundation
protocol FavoritePresenterDelegate: AnyObject{
    func getFavorites()
    func viewDidLoad()
}

class FavoritePresenter: FavoritePresenterDelegate{
    var interactor: FavoriteInteractorDelegate
    var favoriteDataUIWorker: FavoriteTableViewDataUIWorker
    weak var router: RouterDelegate?
    weak var viewDelegate: FavoriteViewDelegate?
    
    init(interactor: FavoriteInteractorDelegate) {
        self.interactor = interactor
        favoriteDataUIWorker = .init()
        favoriteDataUIWorker.getPerformerPhoto = { [weak self] performerId, completion in
            self?.getPerformerPhoto(performerId: performerId, completion: completion)
        }
    }
    
    func viewDidLoad() {
        getFavorites()
    }
    
    func getFavorites() {
        interactor.getFavoritesPerformers { [weak self] performers in
            
            if let favoriteDataUIWorker = self?.favoriteDataUIWorker{
                favoriteDataUIWorker.performers = performers
                self?.viewDelegate?.setTableViewDataSource(dataSource: favoriteDataUIWorker)
                self?.viewDelegate?.setTableViewDelegate(delegate: favoriteDataUIWorker)
                self?.viewDelegate?.reloadTableViewData()
            }
            if performers.isEmpty{
                self?.viewDelegate?.setEmptyListView()
            } else {
                self?.viewDelegate?.removeBackgroundViews()
            }
        }
    }
    
    func getPerformerPhoto(performerId: String, completion: @escaping (Data?) -> Void){
        interactor.getPerformerPhoto(performerId: performerId, completion: completion)
    }
}
