//
//  File.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 04.09.2022.
//

import Foundation
import UIKit

class PerformerInfoViewController: UIViewController{
    weak var profileImageView: UIImageView?
    weak var profileRatingView: UIRatingView?
    weak var profileRatingLabel: UILabel?
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
    }
    
    func setupViews(){
        setupProfileImageView()
        setupProfileRatingView()
        setupProfileRatingLabel()
        setupNameLabel()
        setupPhoneLabel()
        setupDescriptionLabel()
        setupReviewsBlock()
        setupCompletedOrdersLabel()
        setupLastFiveReviewsView()
        setupAllReviewsButton()
        setupSendMessageButton()
    }
    
    func setupSendMessageButton(){
        let button = UIButtonEmassi()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Написать специалисту", for: .normal)
        
        view.addSubview(button)
        sendMessageButton = button
        
        guard let allReviewsButton = allReviewsButton else {
            return
        }
        let bottomConstraint = button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        bottomConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            button.topAnchor.constraint(equalTo: allReviewsButton.bottomAnchor, constant: 10),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            button.heightAnchor.constraint(equalToConstant: UIButtonEmassi.defaultHeight),
            bottomConstraint
        ])
    }
    
    func setupAllReviewsButton(){
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
    
    func setupLastFiveReviewsView(){
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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        lastFiveReviewsView = tableView
        
        guard let completedOrdersLabel = completedOrdersLabel else {
            return
        }
        
        NSLayoutConstraint.activate([
            labelTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            labelTitle.topAnchor.constraint(equalTo: completedOrdersLabel.bottomAnchor, constant: 10),
            
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 5),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    func setupCompletedOrdersLabel(){
        let label = UILabelBordered()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Выполнено 576 заказов"
        
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
    
    func setupReviewsBlock(){
        let blockView = UIView()
        blockView.translatesAutoresizingMaskIntoConstraints = false
        blockView.backgroundColor = .clear
        blockView.setCornerRadius(value: 12)
        blockView.setBorder()
        
        let reviewCountLabel = UILabel()
        reviewCountLabel.translatesAutoresizingMaskIntoConstraints = false
        reviewCountLabel.text = "0 оценок"
        let reviewsRatingView = UIRatingView()
        reviewsRatingView.translatesAutoresizingMaskIntoConstraints = false
        reviewsRatingView.rating = 4
        
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
            reviewCountLabel.centerYAnchor.constraint(equalTo: blockView.centerYAnchor),
            
            reviewsRatingView.topAnchor.constraint(equalTo: blockView.topAnchor,constant: 7),
            reviewsRatingView.trailingAnchor.constraint(equalTo: blockView.trailingAnchor, constant: -10),
            reviewsRatingView.bottomAnchor.constraint(equalTo: blockView.bottomAnchor,constant: -7),
            
            blockView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            blockView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            blockView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
        
    }
    
    func setupDescriptionLabel(){
        let labelTitle = UILabel()
        labelTitle.textColor = .placeholderText
        labelTitle.font = .systemFont(ofSize: 16)
        labelTitle.translatesAutoresizingMaskIntoConstraints  = false
        labelTitle.text = "Описание"
        
        view.addSubview(labelTitle)
        
        let label = UILabelBordered()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = """
reghertghertgretgregregregregreg
        ergregregre

        gregergereghertghertgretgregregregregregergregregregregergereghertghertgretgregregregregregergregregregregergereghertghertgretgregregregregregergregregregregergereghertghertgretgregregregregregergregregregregergereghertghertgretgregregregregregergregregregregergereghertghertgretgregregregregregergregregregregerge
"""
        
        view.addSubview(label)
        descriptionLabel = label
        
        guard let profileImageView = profileImageView else {
            return
        }
        
        NSLayoutConstraint.activate([
            labelTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            labelTitle.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            label.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 5),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
        
    }
    
    func setupPhoneLabel(){
        let label = UILabel()
        label.textAlignment = .left
        label.text = "+79328487228"
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
    
    func setupNameLabel(){
        let label = UILabel()
        label.textAlignment = .left
        label.text = "gfgfdgfdg gfdgdfg dfggfdgf"
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
    
    func setupProfileRatingLabel(){
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20)
        label.text = "3.0"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        profileRatingLabel = label
        
        guard let profileRatingView = profileRatingView else {
            return
        }
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: profileRatingView.trailingAnchor, constant: 5),
            label.centerYAnchor.constraint(equalTo: profileRatingView.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    func setupProfileRatingView(){
        let ratingView = UIRatingView()
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(ratingView)
        profileRatingView = ratingView
        
        guard let profileImageView = profileImageView else {
            return
        }
        
        NSLayoutConstraint.activate([
            ratingView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            ratingView.firstBaselineAnchor.constraint(equalTo: profileImageView.firstBaselineAnchor),
            ratingView.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    func setupProfileImageView(){
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
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor,multiplier: 1.3)
        ])
    }
}
