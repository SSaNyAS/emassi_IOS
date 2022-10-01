//
//  UImageViewPaging.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 30.09.2022.
//

import Foundation
import UIKit

class ImageViewPaging: UIView, UIScrollViewDelegate{
    weak var scrollView: UIScrollView!
    weak var stackView: UIStackView!
    weak var pageControl: UIPageControl?
    
    public var images: [UIImage]{
        get{
            return stackView.arrangedSubviews.compactMap({($0 as? UIImageView)?.image})
        }
        set{
            setImages(images: newValue)
        }
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
        
        for imageId in 0..<images.count {
            let image = images[imageId]
            
            if imageId < imageViewsCount{
                let imageView = stackView.arrangedSubviews[imageId] as? UIImageView
                DispatchQueue.main.async {
                    imageView?.image = image
                }
            } else {
                addImage(image: image)
            }
        }
        setNeedsLayout()
    }
    
    func addImage(image: UIImage){
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        DispatchQueue.main.async {
            self.stackView.addArrangedSubview(imageView)
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
        addSubview(contentScrollView)
        self.scrollView = contentScrollView
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        scrollView.addSubview(stackView)
        self.stackView = stackView
        layer.masksToBounds = true
        setCornerRadius(value: 12)
        
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pageControl)
        self.pageControl = pageControl
        
        pageIndicatorTintColor = .lightGray
        currentPageIndicatorTintColor = .white
        
        NSLayoutConstraint.activate([
            contentScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentScrollView.topAnchor.constraint(equalTo: topAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -5),
            contentScrollView.heightAnchor.constraint(equalTo: contentScrollView.widthAnchor),
            contentScrollView.widthAnchor.constraint(equalTo: widthAnchor),
            contentScrollView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            pageControl.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 5),
            pageControl.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -5),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor),
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}
