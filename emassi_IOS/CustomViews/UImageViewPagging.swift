//
//  UImageViewPaging.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 30.09.2022.
//

import Foundation
import UIKit

class ImageViewPagging: UIView, UIScrollViewDelegate{
    weak var scrollView: UIScrollView!
    weak var stackView: UIStackView!
    weak var pageControl: UIPageControl?
    var heightConstraint: NSLayoutConstraint?
    
    public var images: [UIImage]{
        get{
            return stackView.arrangedSubviews.compactMap({($0 as? UIImageView)?.image})
        }
        set{
            setImages(images: newValue)
        }
    }
    
    private var imageViewsCount: Int{
        return stackView.arrangedSubviews.count
    }
    
    public var currentPageIndicatorTintColor: UIColor?{
        get{
            pageControl?.currentPageIndicatorTintColor
        }
        set{
            DispatchQueue.main.async {
                self.pageControl?.currentPageIndicatorTintColor = newValue
            }
        }
    }
    
    public var pageIndicatorTintColor: UIColor?{
        get{
            pageControl?.pageIndicatorTintColor
        }
        set{
            DispatchQueue.main.async {
                self.pageControl?.pageIndicatorTintColor = newValue
            }
        }
    }
    
    func setImages(images: [UIImage]){
        let imageViewsCount = stackView.arrangedSubviews.count
        if imageViewsCount > images.count {
            let difference = imageViewsCount - images.count
            for removeId in 0..<difference{
                stackView.arrangedSubviews[removeId].removeFromSuperview()
                
            }
        }
        pageControl?.numberOfPages = images.count
        for imageId in 0..<images.count {
            let image = images[imageId]
            
            if imageId < imageViewsCount{
                let imageView = stackView.arrangedSubviews[imageId] as? UIImageView
                DispatchQueue.main.async {
                    imageView?.image = image
                    imageView?.setNeedsLayout()
                }
            } else {
                addImage(image: image)
            }
        }
        setNeedsLayout()
    }
    
    func addImage(image: UIImage){
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleToFill
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        DispatchQueue.main.async {
            self.stackView.addArrangedSubview(imageView)
            imageView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor).isActive = true
            imageView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
            self.pageControl?.numberOfPages = self.imageViewsCount
            self.setNeedsUpdateConstraints()
        }
    }
    
    var currentPage: Int = 0{
        didSet{
            DispatchQueue.main.async {
                self.pageControl?.currentPage = self.currentPage
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaultSettings()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if (self.images.count > 0){
            self.currentPage = Int(targetContentOffset.pointee.x) / Int(scrollView.frame.width)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDefaultSettings()
    }
    
    func setupDefaultSettings(){
        let contentScrollView = UIScrollView()
        contentScrollView.translatesAutoresizingMaskIntoConstraints = false
        contentScrollView.delegate = self
        contentScrollView.isPagingEnabled = true
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.showsVerticalScrollIndicator = false
        contentScrollView.isDirectionalLockEnabled = true
        addSubview(contentScrollView)
        self.scrollView = contentScrollView
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        scrollView.addSubview(stackView)
        self.stackView = stackView
        
        scrollView.layer.masksToBounds = true
        scrollView.setCornerRadius(value: 12)
        
        self.layer.masksToBounds = true
        self.setCornerRadius(value: 12)
        
        stackView.layer.masksToBounds = true
        stackView.setCornerRadius(value: 12)
        
        
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pageControl)
        self.pageControl = pageControl
        
        pageIndicatorTintColor = .placeholderText
        currentPageIndicatorTintColor = .lightGray
        
        NSLayoutConstraint.activate([
            contentScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentScrollView.topAnchor.constraint(equalTo: topAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentScrollView.heightAnchor.constraint(equalTo: contentScrollView.widthAnchor),
            contentScrollView.widthAnchor.constraint(equalTo: widthAnchor),
            contentScrollView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
            
            
            pageControl.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 5),
            pageControl.topAnchor.constraint(equalTo: contentScrollView.bottomAnchor,constant: 5),
            pageControl.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -5),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -10),
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])

        heightConstraint = heightAnchor.constraint(equalToConstant: 0)
        heightConstraint?.priority = .required
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let isHide = self.imageViewsCount == 0
        
        if self.heightConstraint?.isActive != isHide{
            UIView.animate(withDuration: 0.4) {
                self.heightConstraint?.isActive = isHide
                self.isHidden = isHide
            }
            if isHide{
                self.invalidateIntrinsicContentSize()
                setNeedsUpdateConstraints()
            }
        }
    }
}
