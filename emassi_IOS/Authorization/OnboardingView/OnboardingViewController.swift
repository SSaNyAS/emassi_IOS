//
//  OnboardingViewController.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 01.09.2022.
//

import Foundation
import UIKit

class OnboardingViewController: UIViewController{
    
    weak var pageControl: UIPageControl?
    weak var collectionView: UICollectionView?
    weak var loginButton: UIButton?
    weak var registerButton: UIButton?
    weak var router: RouterDelegate?
    
    var items: [OnBoardingItem] = [
        .init(title: "Emassi", image: "onboard1", description: ""),
        .init(title: "Удобно", image: "onboard2", description: "Вы получаете возможность в любой момент найти, нанять и вызвать специалиста."),
        .init(title: "Безопасно", image: "onboard3", description: "Emassi дает возможность вызвать специалиста без предоплаты"),
        .init(title: "Начнем", image: "onboard4", description: "Войдите или зарегистрируйтесь в Emassi"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        loginButton?.setTitle("Войти", for: .normal)
        registerButton?.setTitle("Зарегистрироваться", for: .normal)
        pageControl?.numberOfPages = 4
    }
    
    func setupViews(){
        setupCollectionView()
        setupCollectionViewConstraints()
        
        setupPageControl()
        setupPageControlConstraints()
        
        setupLoginButton()
        setupLoginButtonConstraints()
        
        setupRegisterButton()
        setupRegisterButtonConstraints()
    }
    
    @objc func registerButtonClick(){
        router?.goToViewController(from: self, to: .register, presentationMode: .present)
    }
    
    @objc func loginButtonClick(){
        router?.goToViewController(from: self, to: .login, presentationMode: .present)
    }
    
    @objc func showButtons(){
        let isLastPage = pageControl?.currentPage == items.count - 1
        loginButton?.isHidden = !isLastPage
        registerButton?.isHidden = !isLastPage
    }
    
    func setupRegisterButtonConstraints(){
        guard let registerButton = registerButton, let loginButton = loginButton else {
            return
        }

        NSLayoutConstraint.activate([
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 5),
            registerButton.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
            registerButton.widthAnchor.constraint(equalTo: loginButton.widthAnchor),
            registerButton.heightAnchor.constraint(equalTo: loginButton.heightAnchor),
            registerButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    func setupRegisterButton(){
        let button = UIButtonEmassi()
        button.isHidden = true
        button.addTarget(self, action: #selector(registerButtonClick), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        registerButton = button
    }
    
    func setupLoginButtonConstraints(){
        guard let loginButton = loginButton, let pageControl = pageControl else {
            return
        }
        
        NSLayoutConstraint.activate([
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            loginButton.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 30),
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            loginButton.heightAnchor.constraint(equalToConstant: UIButtonEmassi.defaultHeight)
        ])
    }
    
    func setupLoginButton(){
        let button = UIButtonEmassi()
        button.isHidden = true
        button.addTarget(self, action: #selector(loginButtonClick), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        loginButton = button
    }
    
    func setupCollectionViewConstraints(){
        guard let collectionView = collectionView else {
            return
        }
        let widthConstraint = collectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -20)
        let leadingAnchor = collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10)
        let trailingAnchor = collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10)
        leadingAnchor.priority = .defaultHigh
        trailingAnchor.priority = .defaultHigh
        widthConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            collectionView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor,constant: -80),
            leadingAnchor,
            trailingAnchor,
            
            collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor),
            widthConstraint
            
        ])
    }
    
    func setupCollectionView(){
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        //layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: OnboardingCollectionViewCell.identifire)
        
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentMode = .bottom
        view.addSubview(collectionView)
        self.collectionView = collectionView
        
    }
    
    func setupPageControlConstraints(){
        guard let pageControl = pageControl else {
            return
        }
        guard let collectionView = collectionView else {
            return
        }
        
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            pageControl.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            pageControl.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
            
        ])
    }
    
    func setupPageControl(){
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .gray
        pageControl.pageIndicatorTintColor = .placeholderText
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(pageControl)
        self.pageControl = pageControl
    }
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewSize = collectionView.frame
        let contentInset = collectionView.contentInset
        let width = collectionViewSize.width - contentInset.right - contentInset.left
        let height = collectionViewSize.height - contentInset.top - contentInset.bottom
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifire, for: indexPath)
        if let cell = cell as? OnboardingCollectionViewCell{
            let current = items[indexPath.item]
            cell.imageView.image = UIImage(named: current.image)
            cell.onBoardTitleLabel.text = current.title
            cell.onBoardDescriptionLabel.text = current.description
        }
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if (self.items.count > 0){
            self.pageControl?.currentPage = Int(targetContentOffset.pointee.x) / Int(scrollView.frame.width)
            showButtons()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView?.setNeedsUpdateConstraints()
        collectionView?.collectionViewLayout.invalidateLayout()
    }
 
}
