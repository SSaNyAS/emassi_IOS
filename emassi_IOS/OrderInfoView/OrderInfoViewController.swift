//
//  OrderInfoViewController.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 10.10.2022.
//

import Foundation
import UIKit

protocol OrderInfoViewDelegate: AnyObject{
    func getViewController() -> UIViewController
    func showMessage(message: String, title: String)
    func setProfileImage(imageData: Data?)
    func setProfileRating(rating: Float)
    func setOrderDate(date: String?)
    func setPrice(price: String?)
    func setName(name: String?)
    func setEmail(email: String?, confirmed: Bool?)
    func setPhone(phone: String?, confirmed: Bool?)
    func setAddress(address: String?)
    func setDetails(details: String?)
    func setOrdersCount(count: Int)
    func setReviewsCount(count: Int)
    func setReviewsRating(rating: Float)
    func setPhotos(imagesData: [Data])
    func showInfoForCurrentPerformer()
}

class OrderInfoViewController: UIViewController{
    
    weak var profileImageView: UIImageView?
    weak var ratingView: UIRatingView?
    weak var nameLabel: UILabel?
    
    weak var stackViewForFields: UIStackView?
    weak var reviewsCountLabel: UILabel?
    weak var reviewsRatingView: UIRatingView?
    weak var ordersCountLabel: UILabel?
    weak var orderDateLabel: UILabel?
    weak var priceLabel: UILabel?
    weak var phoneTextField: UITextField?
    weak var addressTextField: UITextField?
    weak var emailTextField: UITextField?
    weak var detailsTextView: UITextView?
    weak var imageContainer: ImageViewPagging?

    weak var createRoadButton: UIButton?
    weak var workCompletedButton: UIButton?
    var presenter: OrderInfoPresenterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Информация о заявке"
        setupViews()
        presenter?.viewDidLoad()
        profileImageView?.isHidden = true
        ratingView?.isHidden = true
        nameLabel?.isHidden = true
        reviewsRatingView?.superview?.isHidden = true
        emailTextField?.superview?.isHidden = true
        phoneTextField?.superview?.isHidden = true
        workCompletedButton?.isHidden = true
        createRoadButton?.isHidden = true
    }
    
    @objc func workCompleteButtonClick(){
        presenter?.workComplete()
    }
    @objc func createRoadButtonClick(){
        presenter?.createRoad()
    }
}


// MARK: PerformerProfile ViewDelegate
extension OrderInfoViewController: OrderInfoViewDelegate {
    
    func showInfoForCurrentPerformer(){
        createRoadButton?.isHidden = false
        workCompletedButton?.isHidden = false
    }
    
    func setOrderDate(date: String?) {
        DispatchQueue.main.async {
            self.orderDateLabel?.text = date
            self.orderDateLabel?.superview?.isHidden = date?.isEmpty ?? true
        }
    }
    
    func setPrice(price: String?) {
        DispatchQueue.main.async {
            self.priceLabel?.text = price
            self.priceLabel?.superview?.isHidden = price?.isEmpty ?? true
        }
    }
    
    func getViewController() -> UIViewController {
        return self
    }
    
    func setAddress(address: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.addressTextField?.text = address
            self?.addressTextField?.superview?.isHidden = address?.isEmpty ?? true
        }
    }
    
    func setProfileImage(imageData: Data?) {
        DispatchQueue.main.async { [weak self] in
            let image = UIImage(data: imageData ?? Data())
            self?.profileImageView?.image = image ?? .noPhotoUser
        }
    }
    
    func setProfileRating(rating: Float) {
        DispatchQueue.main.async { [weak self] in
            self?.ratingView?.rating = rating
        }
    }
    
    func setName(name: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.nameLabel?.text = name
            self?.nameLabel?.isHidden = name?.isEmpty ?? true
            self?.ratingView?.isHidden = name?.isEmpty ?? true
            self?.profileImageView?.isHidden = name?.isEmpty ?? true
            self?.reviewsRatingView?.superview?.isHidden = name?.isEmpty ?? true
            self?.ordersCountLabel?.isHidden = name?.isEmpty ?? true
        }
    }
    
    func setEmail(email: String?, confirmed: Bool?) {
        DispatchQueue.main.async { [weak self, weak emailTextField] in
            guard let self = self else {return}
            emailTextField?.rightView?.removeFromSuperview()
            emailTextField?.rightView = nil
            let confirmedImageView = self.createConfirmedImageView(isConfirmed: confirmed ?? false)
            DispatchQueue.main.async { [weak emailTextField] in
                emailTextField?.rightView = confirmedImageView
                emailTextField?.rightViewMode = .always
            }
            emailTextField?.text = email
            emailTextField?.superview?.isHidden = email?.isEmpty ?? true
        }
    }
    
    func setPhone(phone: String?, confirmed: Bool?) {
        DispatchQueue.main.async { [weak self, weak phoneTextField] in
            guard let self = self else {return}
            phoneTextField?.rightView?.removeFromSuperview()
            phoneTextField?.rightView = nil
            let confirmedImageView = self.createConfirmedImageView(isConfirmed: confirmed ?? false)
            DispatchQueue.main.async { [weak phoneTextField] in
                phoneTextField?.rightView = confirmedImageView
                phoneTextField?.rightViewMode = .always
            }
            phoneTextField?.text = phone
            phoneTextField?.superview?.isHidden = phone?.isEmpty ?? true
        }
    }
    
    func setDetails(details: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.detailsTextView?.text = details
            self?.detailsTextView?.superview?.isHidden = details?.isEmpty ?? true
        }
    }
    
    func setPhotos(imagesData: [Data]) {
        DispatchQueue.main.async { [weak self] in
            var images: [UIImage] = []
            images = imagesData.compactMap({
                UIImage(data: $0)
            })
            self?.imageContainer?.isHidden = images.count < 1
            self?.imageContainer?.images = images
        }
    }
    
    func setOrdersCount(count: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.ordersCountLabel?.text = "Выполнено заказов: \(count)"
        }
    }
    
    func setReviewsCount(count: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.ordersCountLabel?.text = "Оценок: \(count)"
        }
    }
    
    func setReviewsRating(rating: Float) {
        DispatchQueue.main.async { [weak self] in
            self?.reviewsRatingView?.rating = rating
        }
    }
    
    func createConfirmedImageView(isConfirmed: Bool = false) -> UIImageView{
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: isConfirmed ? "checkmark.circle.fill" : "checkmark.circle.badge.xmark.fill")?.applyingSymbolConfiguration(.init(pointSize: 25))?.withTintColor(.baseAppColor, renderingMode: .alwaysOriginal)
        imageView.image = image
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, constant: 30).isActive = true
        return imageView
    }
}

// MARK: Create Views
extension OrderInfoViewController{
    
    private func setupViews(){
        
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
        
        createProfileImageView(in: contentView)
        createRatingView(in: contentView)
        createNameLabel(in: contentView)
        
        createStackViewForFields(in: contentView)
        
        let reviewsCountLabel = createReviewsCountLabel()
        let reviewRatingView = createReviewsRatingView()
        createTwoViewsBlock(with: reviewsCountLabel, other: reviewRatingView)
        createOrdersCountLabel()
        let orderDateLabel = createOrderDateLabel()
        _ = attachLabelToView(with: "Дата и время вызова", createdView: orderDateLabel)
        let orderPriceLabel = createOrderPriceLabel()
        _ = attachLabelToView(with: "Сумма оплаты", createdView: orderPriceLabel)
        
        createTextField(with: "email", attachTo: &emailTextField)
        emailTextField?.textContentType = .emailAddress
        emailTextField?.isUserInteractionEnabled = false
        createTextField(with: "Номер телефона", attachTo: &phoneTextField)
        phoneTextField?.textContentType = .telephoneNumber
        phoneTextField?.isUserInteractionEnabled = false
        createTextField(with: "Адрес", attachTo: &addressTextField)
        addressTextField?.textContentType = .fullStreetAddress
        addressTextField?.isUserInteractionEnabled = false
        if let addressTextField = addressTextField as? UITextFieldEmassi{
            addressTextField.isTextEditable = false
        }
        
        
        createDetailsTextView()
        createImageContainer()
        
        detailsTextView?.isEditable = false
        imageContainer?.isHidden = true
        
        createCreateRoadButton(in: contentView)
        createWorkCompletedButton(in: contentView)
        
        self.reviewsCountLabel?.text = "Оценок: 0"
        ordersCountLabel?.text = "Выполнено заказов: 0"
        
        createRoadButton?.setTitle("Построить маршрут", for: .normal)
        workCompletedButton?.setTitle("Работа выполнена", for: .normal)
        
        createProfileImageViewConstraints(in: contentView)
        createRatingViewConstraints(in: contentView)
        createNameLabelConstraints(in: contentView)
        createStackViewForFieldsConstraints(in: contentView)
        createCreateRoadButtonConstraints(in: contentView)
        createWorkCompletedButtonConstraints(in: contentView)
    }
    
    private func createWorkCompletedButton(in view: UIView){
        let button = UIButtonEmassi()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(workCompleteButtonClick), for: .touchUpInside)
        view.addSubview(button)
        workCompletedButton = button
    }
    
    private func createCreateRoadButton(in view: UIView){
        let button = UIButtonEmassi()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(createRoadButtonClick), for: .touchUpInside)
        view.addSubview(button)
        createRoadButton = button
    }
    
    private func createTwoViewsBlock(with label: UILabel, other view: UIView){
        let contrainer = UIView()
        contrainer.backgroundColor = .clear
        contrainer.setCornerRadius(value: 12)
        contrainer.setBorder()
        contrainer.translatesAutoresizingMaskIntoConstraints = false
        
        contrainer.addSubview(label)
        contrainer.addSubview(view)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contrainer.leadingAnchor, constant: 10),
            label.topAnchor.constraint(greaterThanOrEqualTo: contrainer.topAnchor, constant: 10),
            label.trailingAnchor.constraint(lessThanOrEqualTo: view.leadingAnchor, constant: -20),
            label.bottomAnchor.constraint(lessThanOrEqualTo: contrainer.bottomAnchor, constant: -10),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            view.topAnchor.constraint(greaterThanOrEqualTo: contrainer.topAnchor, constant: 10),
            view.trailingAnchor.constraint(equalTo: contrainer.trailingAnchor, constant: -10),
            view.bottomAnchor.constraint(lessThanOrEqualTo: contrainer.bottomAnchor, constant: -10),
        ])
        stackViewForFields?.addArrangedSubview(contrainer)
    }
    
    private func createReviewsRatingView() -> UIRatingView{
        let ratingView = UIRatingView()
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        reviewsRatingView = ratingView
        return ratingView
    }
    
    private func createReviewsCountLabel() -> UILabel{
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        reviewsCountLabel = label
        return label
    }
    
    private func createOrdersCountLabel(){
        let label = UILabelBordered()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        stackViewForFields?.addArrangedSubview(label)
        ordersCountLabel = label
    }
    
    private func createImageContainer(){
        let imageContainer = ImageViewPagging()
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        stackViewForFields?.addArrangedSubview(imageContainer)
        self.imageContainer = imageContainer
    }
    
    private func createDetailsTextView(){
        let textView = UITextView()
        textView.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        textView.setCornerRadius(value: 12)
        textView.setBorder()
        textView.font = .systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        let minHeight = textView.heightAnchor.constraint(equalToConstant: 80)
        minHeight.priority = .defaultLow
        minHeight.isActive = true
        
        if let view = attachLabelToView(with: "Конфиденциальная информация", createdView: textView) as? UITextView{
            detailsTextView = view
        }
    }
    
    private func attachLabelToView(with titleText: String, createdView: UIView) -> UIView{
        let containerView = UIView()
        let label = createDescriptionLabel()
        label.text = titleText
        createdView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(createdView)
        containerView.addSubview(label)
        
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            label.topAnchor.constraint(equalTo: containerView.topAnchor),
            label.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -5),
            
            createdView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            createdView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 2),
            createdView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            createdView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
        
        stackViewForFields?.addArrangedSubview(containerView)
        return createdView
    }
    
    private func createTextField(with titleText: String, attachTo: inout UITextField?){
        let containerView = UIView()
        let label = createDescriptionLabel()
        label.text = titleText
        let textfield = UITextFieldEmassi()
        textfield.setCornerRadius(value: 12)
        textfield.setBorder()
        textfield.backgroundColor = .clear
        textfield.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(textfield)
        
        containerView.addSubview(label)
        
        attachTo = textfield
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            label.topAnchor.constraint(equalTo: containerView.topAnchor),
            label.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -5),
            
            textfield.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            textfield.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 2),
            textfield.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            textfield.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            textfield.heightAnchor.constraint(equalToConstant: UITextFieldEmassi.defaultHeight),
        ])
        
        stackViewForFields?.addArrangedSubview(containerView)
    }
    
    private func createStackViewForFields(in view: UIView){
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.contentMode = .top
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        self.stackViewForFields = stackView
    }
    
    private func createOrderPriceLabel() -> UILabel{
        let label = UILabelBordered()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        priceLabel = label
        return label
    }
    
    private func createOrderDateLabel() -> UILabel{
        let label = UILabelBordered()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        orderDateLabel = label
        return label
    }
    
    private func createNameLabel(in view: UIView){
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        self.nameLabel = label
    }
    
    private func createDescriptionLabel() -> UILabel{
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .placeholderText
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        return label
    }
    
    private func createRatingView(in view: UIView){
        let ratingView = UIRatingView()
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ratingView)
        self.ratingView = ratingView
    }
    
    private func createProfileImageView(in view: UIView){
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = .noPhotoUser
        imageView.setCornerRadius(value: 12)
        imageView.setBorder()
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        profileImageView = imageView
    }
    
    private func createWorkCompletedButtonConstraints(in view: UIView){
        guard let createRoadButton = createRoadButton, let workCompletedButton = workCompletedButton else{
            return
        }
        
        NSLayoutConstraint.activate([
            workCompletedButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            workCompletedButton.topAnchor.constraint(equalTo: createRoadButton.bottomAnchor, constant: 10),
            workCompletedButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            workCompletedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            workCompletedButton.heightAnchor.constraint(equalToConstant: UIButtonEmassi.defaultHeight),
        ])
    }
    
    private func createCreateRoadButtonConstraints(in view: UIView){
        guard let stackView = stackViewForFields, let createRoadButton = createRoadButton else{
            return
        }
        
        NSLayoutConstraint.activate([
            createRoadButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            createRoadButton.topAnchor.constraint(greaterThanOrEqualTo: stackView.bottomAnchor, constant: 10),
            createRoadButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            createRoadButton.heightAnchor.constraint(equalToConstant: UIButtonEmassi.defaultHeight),
        ])
    }
    
    private func createStackViewForFieldsConstraints(in view: UIView){
        guard let stackView = stackViewForFields, let profileImageView = profileImageView else{
            return
        }
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            stackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
    }
    
    private func createNameLabelConstraints(in view: UIView){
        guard let ratingView = ratingView, let nameLabel = nameLabel else{
            return
        }
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: ratingView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
    }
    
    private func createRatingViewConstraints(in view: UIView){
        guard let ratingView = ratingView, let profileImageView = profileImageView else{
            return
        }
        
        NSLayoutConstraint.activate([
            ratingView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor,constant: 5),
            ratingView.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            ratingView.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
    }
    
    private func createProfileImageViewConstraints(in view: UIView){
        guard let profileImageView = profileImageView else{
            return
        }
        let heightConstraint = profileImageView.heightAnchor.constraint(equalToConstant: 120)
        heightConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            heightConstraint,
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor, multiplier: 1.2),
        ])
    }
}

