//
//  ProfileViewController.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 24.09.2022.
//

import Foundation
import UIKit
enum ProfileMode{
    case customer
    case performer
}

protocol PerformerProfileViewDelegate: AnyObject{
    var profileMode: ProfileMode {get}
    func getViewController() -> UIViewController
    func showMessage(message: String, title: String)
    func setProfileImage(imageData: Data?)
    func loadNewPhoto()
    func setProfileRating(rating: Float)
    func setName(name: String?)
    func setEmail(email: String?, confirmed: Bool?)
    func setPhone(phone: String?, confirmed: Bool?)
    func setAddress(address: String?)
    func setSupportRegions(regions: [MoreSelectorItem])
    func setCategoryList(categories: [MoreSelectorItem])
    func setSelectedCategoryList(categories: [String])
    func setAboutPeformer(aboutText: String?)
    func setOrdersCount(count: Int)
    func setReviewsCount(count: Int)
    func setReviewsRating(rating: Float)
}

class PerformerProfileViewController: UIViewController{
    
    weak var profileImageView: UIImageView?
    weak var loadNewPhotoButton: UIButton?
    weak var ratingView: UIRatingView?
    weak var stackViewForFields: UIStackView?
    weak var nameTextField: UITextField?
    weak var emailTextField: UITextField?
    weak var phoneTextField: UITextField?
    weak var addressTextField: UITextField?
    weak var supportRegionSelector: MoreSelectorView?
    weak var categorySelector: MoreSelectorView?
    weak var aboutPerformer: UITextView?
    weak var ordersCountLabel: UILabel?
    weak var reviewsCountLabel: UILabel?
    weak var reviewsRatingView: UIRatingView?
    weak var saveButton: UIButton?
    weak var goToUserProfileButton: UIButton?
    var presenter: PerformerProfilePresenterDelegate?
    var profileMode: ProfileMode = .performer{
        didSet{
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                UIView.animate(withDuration: 0.4) {
                    self.presenter?.viewDidLoad(profileMode: self.profileMode)
                    let isHideMode = self.profileMode == .customer
                    self.supportRegionSelector?.superview?.isHidden = isHideMode
                    self.categorySelector?.superview?.isHidden = isHideMode
                    self.aboutPerformer?.superview?.isHidden = isHideMode
                    self.goToUserProfileButton?.setTitle( !isHideMode ? "Перейти в профиль пользователя" : "Перейти в профиль исполнителя", for: .normal)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Профиль"
        setupViews()
        presenter?.viewDidLoad(profileMode: profileMode)
    }
    
    @objc func changeProfileMode(){
        self.profileMode = self.profileMode == .performer ? .customer : .performer
    }
    
    @objc func saveButtonClick(){
        presenter?.setAboutPerformer(aboutText: aboutPerformer?.text ?? "")
        presenter?.setUsername(FIO: nameTextField?.text ?? "")
        presenter?.setCategories(categories: categorySelector?.selectedItems ?? [])
        presenter?.setPhoneNumber(phone: phoneTextField?.text ?? "")
        presenter?.setSupportRegions(supportRegions: supportRegionSelector?.selectedItems ?? [])
        presenter?.saveClick(profileMode: profileMode)
    }
}


// MARK: PerformerProfile ViewDelegate
extension PerformerProfileViewController: PerformerProfileViewDelegate {
    func getViewController() -> UIViewController {
        return self
    }
    
    func setAddress(address: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.addressTextField?.text = address
        }
    }
    
    func setProfileImage(imageData: Data?) {
        DispatchQueue.main.async { [weak self] in
            self?.profileImageView?.image = UIImage(data: imageData ?? Data()) ?? .noPhotoUser
        }
    }
    
    @objc func loadNewPhoto() {
        presenter?.pickImage(with: profileMode)
    }
    
    func setProfileRating(rating: Float) {
        DispatchQueue.main.async { [weak self] in
            self?.ratingView?.rating = rating
        }
    }
    
    func setName(name: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.nameTextField?.text = name
        }
    }
    
    func setEmail(email: String?, confirmed: Bool?) {
        DispatchQueue.main.async { [weak self, weak emailTextField] in
            guard let self = self else {return}
            emailTextField?.rightView?.removeFromSuperview()
            emailTextField?.rightView = nil
            if confirmed == false{
                let confirmButton = self.createConfirmButton()
                confirmButton.addTarget(self, action: #selector(self.confirmEmail), for: .touchUpInside)
                emailTextField?.rightView = confirmButton
                emailTextField?.rightViewMode = .unlessEditing
            }else {
                let confirmedImageView = self.createConfirmedImageView()
                DispatchQueue.main.async { [weak emailTextField] in
                    emailTextField?.rightView = confirmedImageView
                    emailTextField?.rightViewMode = .always
                }
            }
            emailTextField?.text = email
        }
    }
    
    func setPhone(phone: String?, confirmed: Bool?) {
        DispatchQueue.main.async { [weak self, weak phoneTextField] in
            guard let self = self else {return}
            phoneTextField?.rightView?.removeFromSuperview()
            phoneTextField?.rightView = nil
            
            if confirmed == false{
                let confirmButton = self.createConfirmButton()
                confirmButton.addTarget(self, action: #selector(self.confirmPhoneNumber), for: .touchUpInside)
                DispatchQueue.main.async { [weak phoneTextField] in
                    phoneTextField?.rightView = confirmButton
                    phoneTextField?.rightViewMode = .unlessEditing
                }
            } else {
                let confirmedImageView = self.createConfirmedImageView()
                DispatchQueue.main.async { [weak phoneTextField] in
                    phoneTextField?.rightView = confirmedImageView
                    phoneTextField?.rightViewMode = .always
                }
            }
                phoneTextField?.text = phone
        }
    }
    
    @objc private func confirmPhoneNumber(){
        print("confirmPhoneNumber")
    }
    
    @objc private func confirmEmail(){
        print("confirmEmail")
    }
    
    func setSupportRegions(regions: [MoreSelectorItem]) {
        DispatchQueue.main.async { [weak self] in
            self?.supportRegionSelector?.selectedItems = regions
        }
    }
    
    func setCategoryList(categories: [MoreSelectorItem]) {
        DispatchQueue.main.async { [weak self] in
            self?.categorySelector?.items = categories
        }
    }
    
    func setSelectedCategoryList(categories: [String]) {
        DispatchQueue.main.async { [weak self] in
            self?.categorySelector?.selectedItemsValues = categories
        }
    }
    
    func setAboutPeformer(aboutText: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.aboutPerformer?.text = aboutText
        }
    }
    
    func setOrdersCount(count: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.ordersCountLabel?.text = "Выполнено \(count) заказов"
        }
    }
    
    func setReviewsCount(count: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.ordersCountLabel?.text = "\(count) оценка"
        }
    }
    
    func setReviewsRating(rating: Float) {
        DispatchQueue.main.async { [weak self] in
            self?.reviewsRatingView?.rating = rating
        }
    }
    
    func createConfirmedImageView() -> UIImageView{
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "checkmark.circle.fill")?.applyingSymbolConfiguration(.init(pointSize: 25))?.withTintColor(.baseAppColor, renderingMode: .alwaysOriginal)
        imageView.image = image
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, constant: 30).isActive = true
        return imageView
    }
    
    func createConfirmButton() -> UIButton{
        let button = UIButton()
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "checkmark.circle.badge.xmark.fill")?.withTintColor(.baseAppColor, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.contentMode = .center
        button.setPreferredSymbolConfiguration(.init(pointSize: 25), forImageIn: .normal)
        button.widthAnchor.constraint(equalTo: button.heightAnchor, constant: 30).isActive = true
        return button
    }
}

// MARK: Create Views
extension PerformerProfileViewController{
    
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
        createLoadNewPhotoButton(in: contentView)
        createRatingView(in: contentView)
        createStackViewForFields(in: contentView)
        createTextField(with: "ФИО", attachTo: &nameTextField)
        createTextField(with: "email", attachTo: &emailTextField)
        emailTextField?.textContentType = .emailAddress
        emailTextField?.isEnabled = false
        createTextField(with: "Номер телефона", attachTo: &phoneTextField)
        createTextField(with: "Адрес", attachTo: &addressTextField)
        if let addressTextField = addressTextField as? UITextFieldEmassi{
            addressTextField.isTextEditable = false
        }
        
        addressTextField?.addTarget(self, action: #selector(openAddressSearchViewController), for: .editingDidBegin)
        
        createSupportRegionSelector()
        createCategorySelector()
        createAboutPerformerView()
        
        let reviewsCountLabel = createReviewsCountLabel()
        let reviewRatingView = createReviewsRatingView()
        createTwoViewsBlock(with: reviewsCountLabel, other: reviewRatingView)
        
        createOrdersCountLabel()
        createSaveButton(in: contentView)
        createGoToUserProfileButton(in: contentView)
        
        self.reviewsCountLabel?.text = "Оценок: 0"
        ordersCountLabel?.text = "Выполнено заказов: 0"
        loadNewPhotoButton?.setTitle("Изменить фото профиля", for: .normal)
        loadNewPhotoButton?.addTarget(self, action: #selector(loadNewPhoto), for: .touchUpInside)
        saveButton?.setTitle("Сохранить", for: .normal)
        saveButton?.addTarget(self, action: #selector(saveButtonClick), for: .touchUpInside)
        goToUserProfileButton?.setTitle("Перейти в профиль пользователя", for: .normal)
        goToUserProfileButton?.addTarget(self, action: #selector(changeProfileMode), for: .touchUpInside)
        supportRegionSelector?.addTargetForAllTextFields(target: self, action: #selector(didSelectSupportRegion(sender:)), for: .editingDidBegin)
        
        createProfileImageViewConstraints(in: contentView)
        createLoadNewPhotoButtonConstraints(in: contentView)
        createRatingViewConstraints(in: contentView)
        createStackViewForFieldsConstraints(in: contentView)
        createSaveButtonConstraints(in: contentView)
        createGoToUserProfileButtonConstraints(in: contentView)
        
    }
    
    @objc private func openAddressSearchViewController(){
        addressTextField?.endEditing(true)
        presenter?.selectAddress(currentValue: addressTextField?.text)
    }
    
    @objc private func didSelectSupportRegion(sender: UITextField){
        sender.endEditing(true)
        presenter?.selectSupportRegion(currentValue: sender.text, allSelectedValues: supportRegionSelector?.selectedItems ?? [])
    }
    
    private func createGoToUserProfileButton(in view: UIView){
        let button = UIButtonEmassi()
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        goToUserProfileButton = button
    }
    
    private func createSaveButton(in view: UIView){
        let button = UIButtonEmassi()
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        saveButton = button
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
    
    private func createAboutPerformerView(){
        let textView = UITextView()
        textView.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        textView.setCornerRadius(value: 12)
        textView.setBorder()
        textView.font = .systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        let minHeight = textView.heightAnchor.constraint(equalToConstant: 80)
        minHeight.priority = .defaultLow
        minHeight.isActive = true
        
        if let view = attachLabelToView(with: "Информация о специалисте", createdView: textView) as? UITextView{
            aboutPerformer = view
        }
    }
    
    private func createCategorySelector(){
        let selector = MoreSelectorView()
        selector.isTextWritable = false
        selector.translatesAutoresizingMaskIntoConstraints = false
        if let view = attachLabelToView(with: "Категория специалиста", createdView: selector) as? MoreSelectorView{
            categorySelector = view
        }
    }
    
    private func createSupportRegionSelector(){
        let selector = MoreSelectorView()
        selector.translatesAutoresizingMaskIntoConstraints = false
        if let view = attachLabelToView(with: "Регион обслуживания", createdView: selector) as? MoreSelectorView{
            supportRegionSelector = view
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
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        self.stackViewForFields = stackView
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
    
    private func createLoadNewPhotoButton(in view: UIView){
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitleColor(.baseAppColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        loadNewPhotoButton = button
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
    
    private func createGoToUserProfileButtonConstraints(in view: UIView){
        guard let saveButton = saveButton, let goToUserProfileButton = goToUserProfileButton else{
            return
        }
        let bottomConstraint = goToUserProfileButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        bottomConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            goToUserProfileButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            goToUserProfileButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 10),
            goToUserProfileButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            goToUserProfileButton.heightAnchor.constraint(equalToConstant: UIButtonEmassi.defaultHeight),
        ])
    }
    
    private func createSaveButtonConstraints(in view: UIView){
        guard let stackView = stackViewForFields, let saveButton = saveButton else{
            return
        }
        
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            saveButton.topAnchor.constraint(greaterThanOrEqualTo: stackView.bottomAnchor, constant: 10),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            saveButton.heightAnchor.constraint(equalToConstant: UIButtonEmassi.defaultHeight),
        ])
    }
    
    private func createStackViewForFieldsConstraints(in view: UIView){
        guard let stackView = stackViewForFields, let ratingView = ratingView else{
            return
        }
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            stackView.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
    }
    
    private func createRatingViewConstraints(in view: UIView){
        guard let ratingView = ratingView, let loadNewPhotoButton = loadNewPhotoButton else{
            return
        }
        
        NSLayoutConstraint.activate([
            ratingView.centerXAnchor.constraint(equalTo: loadNewPhotoButton.centerXAnchor),
            ratingView.topAnchor.constraint(equalTo: loadNewPhotoButton.bottomAnchor, constant: 10),
            ratingView.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            ratingView.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    private func createLoadNewPhotoButtonConstraints(in view: UIView){
        guard let loadNewPhotoButton = loadNewPhotoButton, let profileImage = profileImageView else{
            return
        }
        
        NSLayoutConstraint.activate([
            loadNewPhotoButton.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor),
            loadNewPhotoButton.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 10),
            loadNewPhotoButton.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            loadNewPhotoButton.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
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
            profileImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor, multiplier: 1.2),
        ])
    }
}

