//
//  File.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 04.09.2022.
//

import Foundation
import UIKit
protocol PerformerInfoViewDelegate: NSObjectProtocol{
    func getViewController() -> UIViewController
    func setProfileImage(image: UIImage?)
    func setProfileRating(rating: Float)
    func setName(name: String?)
    func setPhone(phone: String?)
    func setDescription(description: String?)
    func setReviewsCount(count: Int)
    func setReviewsRating(rating: Float)
    func setCompletedOrdersCount(count: Int)
    func setReviewsDataSource(dataSource: UITableViewDataSource)
}

class PerformerInfoViewController: UIViewController, PerformerInfoViewDelegate{
    
    func setProfileImage(image: UIImage?) {
        DispatchQueue.main.async { [weak self] in
            self?.profileImageView?.image = image
        }
    }
    
    func setProfileRating(rating: Float) {
        DispatchQueue.main.async { [weak self] in
            self?.profileRatingView?.rating = rating
        }
    }
    
    func setName(name: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.nameLabel?.text = name
        }
    }
    
    func setPhone(phone: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.phoneLabel?.text = phone
        }
    }
    
    func setDescription(description: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.descriptionLabel?.text = description
        }
    }
    
    func setReviewsCount(count: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.reviewsCountLabel?.text = "\(count) оценок"
        }
    }
    
    func setReviewsRating(rating: Float) {
        DispatchQueue.main.async { [weak self] in
            self?.reviewsRatingView?.rating = rating
        }
    }
    
    func setCompletedOrdersCount(count: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.completedOrdersLabel?.text = "Выполнено \(count) заказов"
        }
    }
    
    func setReviewsDataSource(dataSource: UITableViewDataSource) {
        DispatchQueue.main.async { [weak self] in
            self?.lastFiveReviewsView?.dataSource = dataSource
            self?.lastFiveReviewsView?.reloadData()
        }
    }
    
    weak var profileImageView: UIImageView?
    weak var profileRatingView: UIRatingView?
    weak var nameLabel: UILabel?
    weak var phoneLabel: UILabel?
    weak var descriptionLabel: UILabel?
    weak var reviewsRatingBlock: UIView?
    weak var reviewsCountLabel: UILabel?
    weak var reviewsRatingView: UIRatingView?
    weak var completedOrdersLabel: UILabel?
    weak var lastFiveReviewsView: UITableView?
    weak var allReviewsButton: UIButton?
    weak var sendMessageButton: UIButton?
    weak var sendOfferAsCustomerButton: UIButton?
    var presenter: PerformerInfoPresenterDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.getPerformerInfo()
    }
    
    func getViewController() -> UIViewController{
        return self
    }
    
    @objc private func sendOfferForPerformer(){
        presenter?.sendOfferForPerformer()
    }
    
    func setupViews(){
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            scrollView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            scrollView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            scrollView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
        
        // соблюдать порядок обязательно иначе не будут созданы constraints( чтобы исправить необходимо вынести инициализацию всех обьектов и установку constraints в отдельные методы
        // так же в текущей реализации есть ограничение, что ui элементы необходимо прикреплять к 1 контейнеру ->
        
        setupProfileImageView(attachTo: contentView)
        setupProfileRatingView(attachTo: contentView)
        setupNameLabel(attachTo: contentView)
        setupPhoneLabel(attachTo: contentView)
        setupDescriptionLabel(attachTo: contentView)
        setupReviewsBlock(attachTo: contentView)
        setupCompletedOrdersLabel(attachTo: contentView)
        setupLastFiveReviewsView(attachTo: contentView)
        setupAllReviewsButton(attachTo: contentView)
        setupSendMessageButton(attachTo: contentView)
        setupSendOfferAsCustomerButton(attachTo: contentView)
    }
    
    func setupSendOfferAsCustomerButton(attachTo view: UIView){
        let button = UIButtonEmassi()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Вызвать", for: .normal)
        button.addTarget(self, action: #selector(sendOfferForPerformer), for: .touchUpInside)
        view.addSubview(button)
        sendOfferAsCustomerButton = button
        
        guard let sendMessageButton = sendMessageButton else {
            return
        }
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            button.topAnchor.constraint(equalTo: sendMessageButton.bottomAnchor, constant: 10),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            button.heightAnchor.constraint(equalToConstant: UIButtonEmassi.defaultHeight),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -30)
        ])
    }
    
    func setupSendMessageButton(attachTo view: UIView){
        let button = UIButtonEmassi()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Написать специалисту", for: .normal)
        
        view.addSubview(button)
        sendMessageButton = button
        
        guard let allReviewsButton = allReviewsButton else {
            return
        }
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            button.topAnchor.constraint(equalTo: allReviewsButton.bottomAnchor, constant: 10),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            button.heightAnchor.constraint(equalToConstant: UIButtonEmassi.defaultHeight),
        ])
    }
    
    func setupAllReviewsButton(attachTo view: UIView){
        let button = UIButtonEmassi()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Все отзывы", for: .normal)
        
        view.addSubview(button)
        allReviewsButton = button
        
        guard let lastFiveReviewsView = lastFiveReviewsView else {
            return
        }
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            button.topAnchor.constraint(equalTo: lastFiveReviewsView.bottomAnchor, constant: 5),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: UIButtonEmassi.defaultHeight),
        ])
    }
    
    func setupLastFiveReviewsView(attachTo view: UIView){
        let labelTitle = UILabel()
        labelTitle.textColor = .placeholderText
        labelTitle.font = .systemFont(ofSize: 16)
        labelTitle.translatesAutoresizingMaskIntoConstraints  = false
        labelTitle.text = "Последние 5 отзывов"
        
        view.addSubview(labelTitle)
        
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.setCornerRadius(value: 12)
        tableView.setBorder()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: PerformerReviewsTableViewDataSource.reuseIdentifire)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        lastFiveReviewsView = tableView
        
        guard let completedOrdersLabel = completedOrdersLabel else {
            return
        }
        let minHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 200)
        minHeightConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            labelTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            labelTitle.topAnchor.constraint(equalTo: completedOrdersLabel.bottomAnchor, constant: 10),
            labelTitle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -30),
            
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 5),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            minHeightConstraint
        ])
    }
    
    func setupCompletedOrdersLabel(attachTo view: UIView){
        let label = UILabelBordered()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Выполнено заказов: 0"
        
        view.addSubview(label)
        completedOrdersLabel = label
        
        guard let reviewsRatingBlock = reviewsRatingBlock else {
            return
        }
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            label.topAnchor.constraint(equalTo: reviewsRatingBlock.bottomAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    func setupReviewsBlock(attachTo view: UIView){
        let blockView = UIView()
        blockView.translatesAutoresizingMaskIntoConstraints = false
        blockView.backgroundColor = .clear
        blockView.setCornerRadius(value: 12)
        blockView.setBorder()
        
        let reviewCountLabel = UILabel()
        reviewCountLabel.translatesAutoresizingMaskIntoConstraints = false
        reviewCountLabel.text = "Оценок: 0"
        let reviewsRatingView = UIRatingView()
        reviewsRatingView.translatesAutoresizingMaskIntoConstraints = false
        reviewsRatingView.rating = 0
        
        blockView.addSubview(reviewCountLabel)
        blockView.addSubview(reviewsRatingView)
        
        view.addSubview(blockView)
        
        self.reviewsCountLabel = reviewCountLabel
        self.reviewsRatingView = reviewsRatingView
        self.reviewsRatingBlock = blockView
        
        guard let descriptionLabel = descriptionLabel else {
            return
        }

        NSLayoutConstraint.activate([
            reviewCountLabel.leadingAnchor.constraint(equalTo: blockView.leadingAnchor, constant: 10),
            reviewCountLabel.centerYAnchor.constraint(equalTo: reviewsRatingView.centerYAnchor),
            
            reviewsRatingView.topAnchor.constraint(equalTo: blockView.topAnchor,constant: 7),
            reviewsRatingView.trailingAnchor.constraint(equalTo: blockView.trailingAnchor, constant: -10),
            reviewsRatingView.bottomAnchor.constraint(equalTo: blockView.bottomAnchor,constant: -7),
            
            blockView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            blockView.topAnchor.constraint(equalTo: descriptionLabel.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            blockView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
        
    }
    
    func setupDescriptionLabel(attachTo view: UIView){
        let labelTitle = UILabel()
        labelTitle.textColor = .placeholderText
        labelTitle.font = .systemFont(ofSize: 16)
        labelTitle.translatesAutoresizingMaskIntoConstraints  = false
        labelTitle.text = "Описание"
        
        view.addSubview(labelTitle)
        
        let label = UILabelBordered()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        let minHeight = label.heightAnchor.constraint(equalToConstant: UITextFieldEmassi.defaultHeight)
        minHeight.priority = .defaultLow + 1
        minHeight.isActive = true
        
        view.addSubview(label)
        descriptionLabel = label
        
        guard let profileImageView = profileImageView else {
            return
        }
        
        NSLayoutConstraint.activate([
            labelTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            labelTitle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            labelTitle.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            label.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 5),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
        
    }
    
    func setupPhoneLabel(attachTo view: UIView){
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        phoneLabel = label
        
        guard let profileImageView = profileImageView, let nameLabel = nameLabel else {
            return
        }
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            label.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    func setupNameLabel(attachTo view: UIView){
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        nameLabel = label
        
        guard let profileImageView = profileImageView, let profileRatingView = profileRatingView else {
            return
        }
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            label.topAnchor.constraint(equalTo: profileRatingView.bottomAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    func setupProfileRatingView(attachTo view: UIView){
        let ratingView = UIRatingView()
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        ratingView.isShowRatingLabel = true
        view.addSubview(ratingView)
        profileRatingView = ratingView
        
        guard let profileImageView = profileImageView else {
            return
        }
        
        NSLayoutConstraint.activate([
            ratingView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            ratingView.firstBaselineAnchor.constraint(equalTo: profileImageView.firstBaselineAnchor)
        ])
    }
    
    func setupProfileImageView(attachTo view: UIView){
        let imageView = UIImageView()
        imageView.setCornerRadius(value: 12)
        imageView.setBorder()
        imageView.backgroundColor = .lightText
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "nophotouser")
        
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        profileImageView = imageView
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor,multiplier: 1.2)
        ])
    }
}
