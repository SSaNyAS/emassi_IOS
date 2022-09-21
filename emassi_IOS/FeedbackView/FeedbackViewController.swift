//
//  FeedbackViewController.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 15.09.2022.
//

import Foundation
import UIKit
class FeedbackViewController: UIViewController{
    weak var overRatingViewLabel: UILabel?
    weak var ratingView: UIRatingView?
    weak var overCommentLabel: UILabel?
    weak var commentTextView: UITextView?
    weak var completeButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        title = "Отзыв"
        overRatingViewLabel?.text = "Оцените качество выполненной работы"
        overCommentLabel?.text = "Оставьте свой комментарий"
        completeButton?.setTitle("Завершить", for: .normal)
    }
    
    private func setupViews(){
        view.backgroundColor = .white
        createOverRatingViewLabel()
        createRatingView()
        createOverCommentLabel()
        createCommentTextView()
        createCompleteButton()
        
        setupOverRatingViewLabelConstraints()
        setupRatingViewConstraints()
        setupOverCommentLabelConstraints()
        setupCommentTextViewConstraints()
        setupCompleteButtonConstraints()
    }
    
    private func setupCompleteButtonConstraints(){
        guard let completeButton = completeButton else {
            return
        }
        if let commentTextView = commentTextView {
            commentTextView.bottomAnchor.constraint(lessThanOrEqualTo: completeButton.topAnchor, constant: -50).isActive = true
        }
        
        NSLayoutConstraint.activate([
            completeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -10),
            completeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            completeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10)
        ])
    }
    
    private func setupCommentTextViewConstraints(){
        guard let commentTextView = commentTextView else {
            return
        }
        if let overCommentLabel = overCommentLabel {
            commentTextView.topAnchor.constraint(equalTo: overCommentLabel.bottomAnchor,constant: 2).isActive = true
        }
        let heightConstraint = commentTextView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.4)
        heightConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            commentTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            commentTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            heightConstraint
        ])
    }
    
    private func setupOverCommentLabelConstraints(){
        guard let overCommentLabel = overCommentLabel else {
            return
        }
        
        if let ratingView = ratingView {
            overCommentLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 5).isActive = true
        }
        
        NSLayoutConstraint.activate([
            overCommentLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            overCommentLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
        ])
    }
    
    private func setupRatingViewConstraints(){
        guard let ratingView = ratingView else {
            return
        }
        
        if let overRatingViewLabel = overRatingViewLabel {
            ratingView.topAnchor.constraint(equalTo: overRatingViewLabel.bottomAnchor, constant: 5).isActive = true
        }
        NSLayoutConstraint.activate([
            ratingView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func setupOverRatingViewLabelConstraints(){
        guard let overRatingViewLabel = overRatingViewLabel else {
            return
        }
        NSLayoutConstraint.activate([
            overRatingViewLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            overRatingViewLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func createCompleteButton(){
        let button = UIButtonEmassi()
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        completeButton = button
    }
    
    private func createCommentTextView(){
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16)
        textView.isUserInteractionEnabled = true
        textView.backgroundColor = .white
        textView.setCornerRadius(value: 12)
        textView.setBorder()
        textView.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)
        commentTextView = textView
    }
    
    private func createOverCommentLabel(){
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .placeholderText
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        overCommentLabel = label
    }
    
    private func createRatingView(){
        let ratingView = UIRatingView()
        ratingView.isUserInteractionEnabled = true
        ratingView.rating = 1
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ratingView)
        self.ratingView = ratingView
    }
    
    private func createOverRatingViewLabel(){
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .placeholderText
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        overRatingViewLabel = label
    }
}
