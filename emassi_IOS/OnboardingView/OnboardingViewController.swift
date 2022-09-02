//
//  OnboardingViewController.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 01.09.2022.
//

import Foundation
import UIKit

class OnboardingViewController: UIViewController{
    
    private let sectionInsets: UIEdgeInsets = UIEdgeInsets.init(top: 0, left: 40, bottom: 0, right: 40)
    lazy var pageControl: UIPageControl? = {
        let pageControl = UIPageControl()
        pageControl.tintColor = .lightGray
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    lazy var collectionView: UICollectionView? = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .magenta
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        pageControl?.numberOfPages = 4
        setupViews()
    }
    
    func setupViews(){
        setupCollectionView()
        setupPageControl()
    }
    func setupCollectionView(){
        guard let collectionView = collectionView else {
            return
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: OnboardingCollectionViewCell.identifire)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            collectionView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
        ])
        
    }
    
    func setupPageControl(){
        guard let pageControl = pageControl else {
            return
        }
        guard let collectionView = collectionView else {
            return
        }
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            pageControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            pageControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40)
            //pageControl.bottomAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20)
        ])
    }
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewSize = collectionView.bounds
        let width = collectionViewSize.width - sectionInsets.left - sectionInsets.right
        let height = collectionViewSize.height - sectionInsets.top - sectionInsets.bottom
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifire, for: indexPath)
        if let cell = cell as? OnboardingCollectionViewCell{
            cell.imageView?.image = .checkmark
            cell.onBoardTitleLabel?.text = "Title label"
            cell.onBoardDescriptionLabel?.text = "DESRIPTION,DESRIPTION,DESRIPTION,DESRIPTION,DESRIPTION,DESRIPTION,DESRIPTION,DESRIPTION,DESRIPTION,DESRIPTION,DESRIPTION,DESRIPTION,DESRIPTION,DESRIPTION,DESRIPTION,DESRIPTION,DESRIPTION,DESRIPTION,"
        }
        return cell
    }
    
    
}
