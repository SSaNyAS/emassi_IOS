//
//  UIRatingView.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 04.09.2022.
//

import Foundation
import UIKit

class UIRatingView: UIView{
    private weak var stackView: UIStackView?
    
    private lazy var ratingLabel: UILabel? = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultHigh + 2, for: .horizontal)
        DispatchQueue.main.async {
            self.addSubview(label)
            if let stackView = self.stackView, let label = self.ratingLabel{
                NSLayoutConstraint.activate([
                    label.leadingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 5),
                    label.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
                    label.topAnchor.constraint(lessThanOrEqualTo: stackView.topAnchor),
                    label.bottomAnchor.constraint(greaterThanOrEqualTo: stackView.bottomAnchor),
                    label.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
                ])
            }
        }
        return label
    }()
    
    @MainActor
    public var starsCount: Int = 5
    {
        didSet{
            reDrawStars()
        }
    }
    
    public var isShowRatingLabel: Bool = false{
        didSet{
            DispatchQueue.main.async {
                if self.isShowRatingLabel{
                    self.ratingLabel?.text = "0.0"
                }
                else {
                    self.ratingLabel?.removeFromSuperview()
                    self.ratingLabel = nil
                }
            }
        }
    }
    
    @MainActor
    override var isUserInteractionEnabled: Bool{
        didSet{
            reDrawStars()
        }
    }
    @MainActor
    public var starSpacing: CGFloat = 5{
        didSet{
            stackView?.spacing = starSpacing
            setNeedsLayout()
        }
    }
    @MainActor
    public var starImage = UIImage(systemName: "star.fill"){
        didSet{
            reDrawStars()
        }
    }
    
    @MainActor
    public var filledStarColor: UIColor = .systemYellow{
        didSet{
            setRating(rating)
        }
    }

    public var emptyStarColor: UIColor = .placeholderText{
        didSet{
            setRating(rating)
        }
    }

    
    public var rating: Float = 0.0{
        didSet{
            setRating(rating)
        }
    }
    
    init(){
        super.init(frame: .zero)
        setupDefaultSettings()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaultSettings()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDefaultSettings()
    }
    
    @MainActor
    private func setRating(_ rating: Float){
        for item in 0..<(stackView?.arrangedSubviews.count ?? 0){
            stackView?.arrangedSubviews[item].tintColor = item <= Int(rating)-1 ? filledStarColor : emptyStarColor
        }
        
        if isShowRatingLabel{
            DispatchQueue.main.async {
                self.ratingLabel?.text = "\(rating)"
            }
        }
        setNeedsLayout()
    }
    
    private func reDrawStars(){
        stackView?.arrangedSubviews.forEach({$0.removeFromSuperview()})
        drawStars(starsCount: starsCount)
        setRating(rating)
    }
    
    private func drawStars(starsCount: Int){
        for _ in 0..<starsCount{
            let imageView = UIImageView()
            imageView.image = starImage
            imageView.tintColor = .placeholderText
            imageView.contentMode = .scaleAspectFit
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
            imageView.setContentCompressionResistancePriority(.required, for: .vertical)
            if isUserInteractionEnabled{
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didPressOnStar(sender:)))
                imageView.isUserInteractionEnabled = isUserInteractionEnabled
                imageView.addGestureRecognizer(tapGesture)
            }
            stackView?.addArrangedSubview(imageView)
        }
    }
    
    @objc private func didPressOnStar(sender: UITapGestureRecognizer){
        if let tappedView = sender.view{
            if let tappedIndex = stackView?.arrangedSubviews.firstIndex(of: tappedView){
                let tappedRating = Float(tappedIndex) + 1
                if tappedRating == rating {
                    rating = 0
                } else {
                    rating = tappedRating
                }
            }
        }
    }
    
    func setupDefaultSettings(){
        let stackView = UIStackView()
        stackView.contentMode = .topLeft
        stackView.spacing = starSpacing
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        self.stackView = stackView
        let stackViewToTrailingConstraint = stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        stackViewToTrailingConstraint.priority = .defaultHigh + 1
        stackViewToTrailingConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        isUserInteractionEnabled = false
        //reDrawStars()
    }
}
