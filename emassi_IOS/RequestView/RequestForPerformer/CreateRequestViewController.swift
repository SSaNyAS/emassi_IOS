//
//  CreateRequestViewController.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 17.09.2022.
//

import Foundation
import UIKit
import Combine

protocol CreateRequestViewDelegate: AnyObject{
    func getViewController() -> UIViewController
    func showMessage(message: String, title: String)
    func setLocalizationAddress(address: String?)
    func setCallAddress(address: String?)
    func setPhone(phone: String?)
    func setSelectableCategories(categories: [MoreSelectorItem])
    func setSelectedCategory(category: MoreSelectorItem)
    func addPhotoButtonClick()
    func addPhoto(imageData: Data?)
    func createRequestButtonClick()
    
    func setMinimumDate()
}

class CreateRequestViewController: UIViewController, CreateRequestViewDelegate{
    weak var scrollContentView: UIView!
    
    weak var categorySelectorLabel: UILabel?
    weak var categorySelector: UIPickerItemSelector?
    weak var categoryTextField: UITextField?
    
    weak var requestLocalizationLabel: UILabel?
    weak var requestLocalizationTextField: UITextField?
    
    weak var orderDateLabel: UILabel?
    weak var orderDateFromPicker: UIDatePicker?
    weak var orderDateToPicker: UIDatePicker?
    
    weak var orderTimeLabel: UILabel?
    weak var orderTimeFromPicker: UIDatePicker?
    weak var orderTimeToPicker: UIDatePicker?
    
    weak var orderSumLabel: UILabel?
    weak var orderSumTextField: UITextField?
    
    weak var phoneNumberLabel: UILabel?
    weak var phoneNumberTextField: UITextField?
    
    weak var addressLabel: UILabel?
    weak var addressTextField: UITextField?
    
    weak var commentsLabel: UILabel?
    weak var commentsTextView: UITextView?
    
    weak var privateInfoLabel: UILabel?
    weak var privateInfoTextView: UITextView?
    
    weak var imageContainer: ImageViewPagging?
    
    weak var addPhotoButton: UIButton?
    weak var createOrderButton: UIButton?
    var presenter: CreateRequestPresenterDelegate?
    var timer: Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        presenter?.viewDidLoad()
        self.timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            DispatchQueue.main.async {
                self.setMinimumDate()
            }
        }
        timer?.fire()
    }

    func getViewController() -> UIViewController {
        return self
    }
    
    func setLocalizationAddress(address: String?) {
        DispatchQueue.main.async {
            self.requestLocalizationTextField?.text = address
            self.requestLocalizationTextField?.endEditing(true)
        }
    }
    
    func setCallAddress(address: String?) {
        DispatchQueue.main.async {
            self.addressTextField?.text = address
            self.addressTextField?.endEditing(true)
        }
    }
    
    func setPhone(phone: String?) {
        DispatchQueue.main.async {
            self.phoneNumberTextField?.text = phone
        }
    }
    
    func addPhoto(imageData: Data?) {
        if let image = UIImage(data: imageData ?? Data()){
            imageContainer?.addImage(image: image)
        }
    }
    
    func setSelectableCategories(categories: [MoreSelectorItem]) {
        DispatchQueue.main.async {
            self.categorySelector?.items = categories
        }
    }
    
    func setSelectedCategory(category: MoreSelectorItem){
        DispatchQueue.main.async {
            self.categorySelector?.selectedItem = category
            self.categorySelector?.endEditing(true)
        }
    }
    
    @objc func addPhotoButtonClick(){
        presenter?.addPhoto()
    }
    
    @objc func localizationAddressTextFieldDidPress(){
        requestLocalizationTextField?.endEditing(true)
        presenter?.selectLocalizationAddress(currentText: requestLocalizationTextField?.text)
    }
    
    @objc func callAddressTextFieldDidPress(){
        addressTextField?.endEditing(true)
        presenter?.selectCallAddress(currentText: addressTextField?.text)
    }
    
    @objc func createRequestButtonClick(){
        presenter?.setCategory(category: categorySelector?.selectedItem)
        presenter?.setPhone(phone: phoneNumberTextField?.text)
        presenter?.setComments(comments: commentsTextView?.text)
        presenter?.setPrice(price: orderSumTextField?.text)
        presenter?.setDate(from: orderDateFromPicker?.date,to: orderDateToPicker?.date)
        var fromHour: Int?
        var toHour: Int?
        if let fromDate = orderTimeFromPicker?.date{
            let hour = Calendar.current.dateComponents([.hour,.minute], from: fromDate)
            fromHour = hour.hour
        }
        if let ToDate = orderTimeFromPicker?.date{
            let hour = Calendar.current.dateComponents([.hour,.minute,], from: ToDate)
            toHour = hour.hour
        }
        presenter?.setTime(from: fromHour ?? 0, to: toHour ?? 24)
        presenter?.setDetails(details: privateInfoTextView?.text)
        presenter?.createRequest()
    }
    
    @objc private func orderDateToChanged(){
        if let selectedDate = orderDateToPicker?.date{
            DispatchQueue.main.async { [weak orderTimeToPicker] in
                orderTimeToPicker?.setDate(selectedDate, animated: true)
            }
        }
    }
    
    private func setCurrentDate(){
        DispatchQueue.main.async { [weak self] in
            self?.orderDateFromPicker?.setDate(Date().addingTimeInterval(60*60*24), animated: true)
            self?.orderDateToPicker?.setDate(Date().addingTimeInterval(60*60*24 + 60*60*24), animated: true)
            self?.orderTimeToPicker?.setDate(Date().addingTimeInterval(60*60*24 + 60*60*24), animated: true)
        }
    }
    
    @objc func setMinimumDate(){
        DispatchQueue.main.async { [weak self] in
            let addingToNextDayValue: TimeInterval = 60*60*24
            let datePlusOneYear = Date().addingTimeInterval(addingToNextDayValue*365)
            let nextDay = Date().addingTimeInterval(addingToNextDayValue)
            self?.orderDateFromPicker?.minimumDate = nextDay
            self?.orderDateFromPicker?.maximumDate = datePlusOneYear
            
            self?.orderDateToPicker?.minimumDate = nextDay
            self?.orderDateToPicker?.maximumDate = datePlusOneYear
        }
    }
    
}

// MARK: Setup Views Content

extension CreateRequestViewController{
    private func setupViews(){
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        scrollContentView = contentView
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            scrollView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            scrollView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
        
        createCategorySelectorLabel()
        createCategoryTextField()
        
        createRequestLocalizationLabel()
        createRequestLocalizationTextField()
        
        createOrderDateLabel()
        createOrderDateFromPicker()
        createOrderDateToPicker()
        
        createOrderTimeLabel()
        createOrderTimeFromTextField()
        createOrderTimeToTextField()
        
        createOrderSumLabel()
        createOrderSumTextField()
        
        createPhoneNumberLabel()
        createPhoneNumberTextField()
        
        createAddressLabel()
        createAddressTextField()
        
        createCommentsLabel()
        createCommentsTextView()
        
        createPrivateInfoLabel()
        createPrivateInfoTextView()
        
        createImageContainer()
        
        createAddPhotoButton()
        createCreateOrderButton()
        
        title = "Оформить вызов"
        categorySelectorLabel?.text = "Выбор категории"
        requestLocalizationLabel?.text = "Локализация заявки"
        orderDateLabel?.text = "Дата вызова"
        orderTimeLabel?.text = "Время вызова"
        orderSumLabel?.text = "Сумма оплаты"
        phoneNumberLabel?.text = "Номер телефона"
        addressLabel?.text = "Адрес вызова"
        commentsLabel?.text = "Комментарии"
        privateInfoLabel?.text = "Конфиденциальная информация"
        
        addPhotoButton?.setTitle("Добавить фото", for: .normal)
        createOrderButton?.setTitle("Оформить", for: .normal)
        
        addPhotoButton?.addTarget(self, action: #selector(addPhotoButtonClick), for: .touchUpInside)
        createOrderButton?.addTarget(self, action: #selector(createRequestButtonClick), for: .touchUpInside)
        
        requestLocalizationTextField?.addTarget(self, action: #selector(localizationAddressTextFieldDidPress), for: .editingDidBegin)
        addressTextField?.addTarget(self, action: #selector(callAddressTextFieldDidPress), for: .editingDidBegin)

        setCurrentDate()
        
        orderDateToPicker?.addTarget(self, action: #selector(orderDateToChanged), for: .valueChanged)
        setupViewsConstraints(to: scrollContentView)
    }
}

// MARK: Setup Views Constraints
extension CreateRequestViewController{
    private func setupViewsConstraints(to view: UIView){
        setupCategorySelectorConstraints(view: view)
        
        setupRequestLocalizationConstraints(view: view)
        
        setupOrderDateConstraints(view: view)
        
        setupOrderTimeConstraints(view: view)
        
        setupOrderSumConstraints(view: view)
        
        setupPhoneNumberConstraints(view: view)
        
        setupAddressConstraints(view: view)
        
        setupCommentsConstraints(view: view)
        
        setupImageConstainerConstraints(view: view)
        
        setupAddPhotoButtonConstraints(view: view)
        setupCreateOrderButtonConstraints(view: view)
        
        setupPrivateInfoConstraints(view: view)
    }
    
    private func setupCreateOrderButtonConstraints(view: UIView){
        guard let createOrderButton = createOrderButton else {
            return
        }
        
        if let addPhotoButton = addPhotoButton{
            createOrderButton.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: 10).isActive = true
            createOrderButton.heightAnchor.constraint(equalTo: addPhotoButton.heightAnchor).isActive = true
        }
        
        NSLayoutConstraint.activate([
            createOrderButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            createOrderButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            createOrderButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
    }
    
    private func setupAddPhotoButtonConstraints(view: UIView){
        guard let addPhotoButton = addPhotoButton else {
            return
        }
        
        if let imageContainer = imageContainer{
            addPhotoButton.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 10).isActive = true
        }
        
        NSLayoutConstraint.activate([
            addPhotoButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            addPhotoButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            addPhotoButton.heightAnchor.constraint(equalToConstant: UIButtonEmassi.defaultHeight),
        ])
    }
    
    private func setupImageConstainerConstraints(view: UIView){
        guard let imageContainer = imageContainer else {
            return
        }
        
        if let privateInfoTextView = privateInfoTextView{
            imageContainer.topAnchor.constraint(equalTo: privateInfoTextView.bottomAnchor, constant: 10).isActive = true
        }

        NSLayoutConstraint.activate([
            imageContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            imageContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
    }
    
    private func setupPrivateInfoConstraints(view: UIView){
        guard let privateInfoLabel = privateInfoLabel,
              let privateInfoTextView = privateInfoTextView else {
            return
        }
        
        if let commentsTextView = commentsTextView{
            privateInfoLabel.topAnchor.constraint(equalTo: commentsTextView.bottomAnchor, constant: 10).isActive = true
        }
        let heightConstraint = privateInfoTextView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3)
        heightConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            
            privateInfoLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            privateInfoLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            
            privateInfoTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            privateInfoTextView.topAnchor.constraint(equalTo: privateInfoLabel.bottomAnchor, constant: 2),
            privateInfoTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            heightConstraint
        ])
    }
    
    private func setupCommentsConstraints(view: UIView){
        guard let commentsLabel = commentsLabel,
              let commentsTextView = commentsTextView else {
            return
        }
        
        if let addressTextField = addressTextField{
            commentsLabel.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 10).isActive = true
        }
        let heightConstraint = commentsTextView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3)
        heightConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            
            commentsLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            commentsLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            
            commentsTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            commentsTextView.topAnchor.constraint(equalTo: commentsLabel.bottomAnchor, constant: 2),
            commentsTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            heightConstraint
        ])
    }
    
    private func setupAddressConstraints(view: UIView){
        guard let addressLabel = addressLabel,
              let addressTextField = addressTextField else {
            return
        }
        
        if let phoneNumberTextField = phoneNumberTextField{
            addressLabel.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: 10).isActive = true
            addressTextField.heightAnchor.constraint(equalTo: phoneNumberTextField.heightAnchor).isActive = true
        }
        
        NSLayoutConstraint.activate([
            addressLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            addressLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            
            addressTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            addressTextField.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 2),
            addressTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
    }
    
    private func setupPhoneNumberConstraints(view: UIView){
        guard let phoneNumberLabel = phoneNumberLabel,
              let phoneNumberTextField = phoneNumberTextField else {
            return
        }
        
        if let orderSumTextField = orderSumTextField{
            phoneNumberLabel.topAnchor.constraint(equalTo: orderSumTextField.bottomAnchor, constant: 10).isActive = true
            phoneNumberTextField.heightAnchor.constraint(equalTo: orderSumTextField.heightAnchor).isActive = true
        }
        
        NSLayoutConstraint.activate([
            phoneNumberLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            phoneNumberLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            
            phoneNumberTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            phoneNumberTextField.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: 2),
            phoneNumberTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
    }
    
    private func setupOrderSumConstraints(view: UIView){
        guard let orderSumLabel = orderSumLabel,
              let orderSumTextField = orderSumTextField else {
            return
        }
        
        if let orderTimeFromPicker = orderTimeFromPicker{
            orderSumLabel.topAnchor.constraint(equalTo: orderTimeFromPicker.bottomAnchor, constant: 10).isActive = true
        }
        
        NSLayoutConstraint.activate([
            orderSumLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            orderSumLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            
            orderSumTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            orderSumTextField.topAnchor.constraint(equalTo: orderSumLabel.bottomAnchor, constant: 2),
            orderSumTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            orderSumTextField.heightAnchor.constraint(equalToConstant: UITextFieldEmassi.defaultHeight)
        ])
    }
    
    private func setupOrderTimeConstraints(view: UIView){
        guard let orderTimeLabel = orderTimeLabel,
              let orderTimeFromPicker = orderTimeFromPicker,
              let orderTimeToPicker = orderTimeToPicker else {
            return
        }
        
        let betweenLabel = createDescriptionLabel()
        betweenLabel.text = "До"
        betweenLabel.translatesAutoresizingMaskIntoConstraints = false
        betweenLabel.setContentHuggingPriority(.required, for: .horizontal)
        view.addSubview(betweenLabel)
        
        if let orderDateFromPicker = orderDateFromPicker{
            orderTimeLabel.topAnchor.constraint(equalTo: orderDateFromPicker.bottomAnchor, constant: 10).isActive = true
        }
        
        NSLayoutConstraint.activate([
            orderTimeLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            orderTimeFromPicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            orderTimeFromPicker.topAnchor.constraint(equalTo: orderTimeLabel.bottomAnchor, constant: 2),
            orderTimeFromPicker.trailingAnchor.constraint(equalTo: betweenLabel.leadingAnchor, constant: -5),
            
            betweenLabel.centerYAnchor.constraint(equalTo: orderTimeFromPicker.centerYAnchor),
            betweenLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            orderTimeToPicker.leadingAnchor.constraint(equalTo: betweenLabel.trailingAnchor, constant: 5),
            orderTimeToPicker.topAnchor.constraint(equalTo: orderTimeFromPicker.topAnchor),
            orderTimeToPicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
        ])
        
    }
    
    private func setupOrderDateConstraints(view: UIView){
        guard let orderDateLabel = orderDateLabel,
              let orderDateFromPicker = orderDateFromPicker,
              let orderDateToPicker = orderDateToPicker else {
            return
        }
        let betweenLabel = createDescriptionLabel()
        betweenLabel.text = "До"
        betweenLabel.translatesAutoresizingMaskIntoConstraints = false
        betweenLabel.setContentHuggingPriority(.required, for: .horizontal)
        view.addSubview(betweenLabel)
        
        if let requestLocalizationTextField = requestLocalizationTextField{
            orderDateLabel.topAnchor.constraint(equalTo: requestLocalizationTextField.safeAreaLayoutGuide.bottomAnchor, constant: 5).isActive = true
        }
        NSLayoutConstraint.activate([
            orderDateLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),

            
            orderDateFromPicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            orderDateFromPicker.topAnchor.constraint(equalTo: orderDateLabel.bottomAnchor, constant: 2),
            orderDateFromPicker.trailingAnchor.constraint(equalTo: betweenLabel.leadingAnchor, constant: -5),
            
            betweenLabel.centerYAnchor.constraint(equalTo: orderDateFromPicker.centerYAnchor),
            betweenLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            orderDateToPicker.leadingAnchor.constraint(equalTo: betweenLabel.trailingAnchor, constant: 5),
            orderDateToPicker.topAnchor.constraint(equalTo: orderDateFromPicker.topAnchor),
            orderDateToPicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
    }
    
    private func setupRequestLocalizationConstraints(view: UIView){
        guard let requestLocalizationLabel = requestLocalizationLabel, let requestLocalizationTextField = requestLocalizationTextField else {
            return
        }
        
        if let categoryTextField = categoryTextField{
            requestLocalizationLabel.topAnchor.constraint(equalTo: categoryTextField.safeAreaLayoutGuide.bottomAnchor, constant: 5).isActive = true
        }
        
        NSLayoutConstraint.activate([
            requestLocalizationLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 15),
            
            requestLocalizationLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            
            requestLocalizationTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            requestLocalizationTextField.topAnchor.constraint(equalTo: requestLocalizationLabel.bottomAnchor, constant: 2),
            requestLocalizationTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            requestLocalizationTextField.heightAnchor.constraint(equalToConstant: UITextFieldEmassi.defaultHeight)
            
        ])
    }
    
    private func setupCategorySelectorConstraints(view: UIView){
        guard let categoryTextField = categoryTextField, let categorySelectorLabel = categorySelectorLabel else {
            return
        }
        
        NSLayoutConstraint.activate([
            categorySelectorLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 15),
            categorySelectorLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            categorySelectorLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            
            categoryTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            categoryTextField.topAnchor.constraint(equalTo: categorySelectorLabel.bottomAnchor, constant: 2),
            categoryTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            categoryTextField.heightAnchor.constraint(equalToConstant: UITextFieldEmassi.defaultHeight)
            
        ])
    }
}

// MARK: Create Views
extension CreateRequestViewController{
    private func createCreateOrderButton(){
        let button = UIButtonEmassi()
        button.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.addSubview(button)
        createOrderButton = button
    }
    
    private func createAddPhotoButton(){
        let button = UIButtonEmassi()
        button.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.addSubview(button)
        addPhotoButton = button
    }
    
    private func createImageContainer(){
        let imagePaggingView = ImageViewPagging()
        imagePaggingView.setCornerRadius(value: 12)
        imagePaggingView.layer.masksToBounds = true
        imagePaggingView.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.addSubview(imagePaggingView)
        imageContainer = imagePaggingView
    }
    
    private func createPrivateInfoTextView(){
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16)
        textView.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        textView.isUserInteractionEnabled = true
        textView.setCornerRadius(value: 12)
        textView.layer.masksToBounds = true
        textView.setBorder()
        textView.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.addSubview(textView)
        privateInfoTextView = textView
    }
    
    private func createPrivateInfoLabel(){
        let label = createDescriptionLabel()
        scrollContentView.addSubview(label)
        privateInfoLabel = label
    }
    
    private func createCommentsTextView(){
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16)
        textView.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        textView.isUserInteractionEnabled = true
        textView.setCornerRadius(value: 12)
        textView.layer.masksToBounds = true
        textView.setBorder()
        textView.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.addSubview(textView)
        commentsTextView = textView
    }
    
    private func createCommentsLabel(){
        let label = createDescriptionLabel()
        scrollContentView.addSubview(label)
        commentsLabel = label
    }
    
    private func createAddressTextField(){
        let textfield = createTextField()
        textfield.isTextEditable = false
        textfield.textContentType = .streetAddressLine1
        scrollContentView.addSubview(textfield)
        addressTextField = textfield
    }
    
    private func createAddressLabel(){
        let label = createDescriptionLabel()
        scrollContentView.addSubview(label)
        addressLabel = label
    }
    
    private func createPhoneNumberTextField(){
        let textfield = createTextField()
        textfield.textContentType = .telephoneNumber
        scrollContentView.addSubview(textfield)
        phoneNumberTextField = textfield
    }
    
    private func createPhoneNumberLabel(){
        let label = createDescriptionLabel()
        scrollContentView.addSubview(label)
        phoneNumberLabel = label
    }
    
    private func createOrderSumTextField(){
        let textfield = createTextField()
        scrollContentView.addSubview(textfield)
        orderSumTextField = textfield
    }
    
    private func createOrderSumLabel(){
        let label = createDescriptionLabel()
        scrollContentView.addSubview(label)
        orderSumLabel = label
    }
    
    private func createOrderTimeToTextField(){
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.contentHorizontalAlignment = .leading
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.addSubview(datePicker)
        orderTimeToPicker = datePicker
    }
    
    private func createOrderTimeFromTextField(){
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.contentHorizontalAlignment = .trailing
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.addSubview(datePicker)
        orderTimeFromPicker = datePicker
    }
    
    private func createOrderTimeLabel(){
        let label = createDescriptionLabel()
        scrollContentView.addSubview(label)
        orderTimeLabel = label
    }
    
    private func createOrderDateToPicker(){
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.contentHorizontalAlignment = .leading
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.addSubview(datePicker)
        orderDateToPicker = datePicker
    }
    
    private func createOrderDateFromPicker(){
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.contentHorizontalAlignment = .trailing
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.addSubview(datePicker)
        orderDateFromPicker = datePicker
    }
    
    private func createOrderDateLabel(){
        let label = createDescriptionLabel()
        scrollContentView.addSubview(label)
        orderDateLabel = label
    }
    
    private func createRequestLocalizationTextField(){
        let textfield = createTextField()
        textfield.isTextEditable = false
        scrollContentView.addSubview(textfield)
        requestLocalizationTextField = textfield
    }
    
    private func createRequestLocalizationLabel(){
        let label = createDescriptionLabel()
        scrollContentView.addSubview(label)
        self.requestLocalizationLabel = label
    }
    
    private func createCategoryTextField(){
        let textfield = createTextField()
        textfield.isTextEditable = false
        scrollContentView.addSubview(textfield)
        categoryTextField = textfield
        textfield.inputView = categorySelector
        categorySelector?.parentTextField = textfield
        createCategorySelector()
    }
    
    private func createCategorySelector(){
        let categorySelector = UIPickerItemSelector()
        categorySelector.parentTextField = categoryTextField
        categoryTextField?.inputView = categorySelector
        self.categorySelector = categorySelector
    }
    
    private func createCategorySelectorLabel(){
        let categorySelectorLabel = createDescriptionLabel()
        scrollContentView.addSubview(categorySelectorLabel)
        self.categorySelectorLabel = categorySelectorLabel
    }
    
    private func createTextField() -> UITextFieldEmassi{
        let textfield = UITextFieldEmassi()
        textfield.backgroundColor = .systemBackground
        textfield.setBorder()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }
    
    private func createDescriptionLabel() -> UILabel{
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .placeholderText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
