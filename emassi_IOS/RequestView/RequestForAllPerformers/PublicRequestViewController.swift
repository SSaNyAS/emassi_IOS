//
//  CreateOrderViewController.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 17.09.2022.
//

import Foundation
import UIKit

protocol PublicRequestViewDelegate: AnyObject{
    func getViewController() -> UIViewController
    func showMessage(message: String, title: String)
    func setPhone(phone: String?)
    func setAddress(address: String?)
    func addPhoto(imageData: Data?)
}

class PublicRequestViewController: UIViewController, PublicRequestViewDelegate{
    weak var scrollContentView: UIView!
    
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
    
    weak var imageContainer: UIStackView?
    
    weak var addPhotoButton: UIButton?
    weak var createOrderButton: UIButton?
    var presenter: PublicRequestPresenterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (orderDateFromPicker?.minimumDate?.timeIntervalSinceNow ?? 0) < (-10) {
            setMinimumDate()
        }
    }
    
    func getViewController() -> UIViewController {
        return self
    }
    
    func setPhone(phone: String?) {
        DispatchQueue.main.async { [weak phoneNumberTextField] in
            phoneNumberTextField?.text = phone
        }
    }
    
    func setAddress(address: String?) {
        DispatchQueue.main.async { [weak addressTextField] in
            addressTextField?.text = address
        }
    }
    
    func addPhoto(imageData: Data?) {
        DispatchQueue.main.async { [weak imageContainer] in
            let image = UIImage(data: imageData ?? Data())
            imageContainer?.addArrangedSubview(UIImageView(image: image))
        }
    }
    
    @objc private func addPhotoButtonClick(){
        presenter?.addPhoto()
    }
    
    @objc private func createPublicRequest(){
        presenter?.createPublicRequest()
    }
    
    @objc private func orderDateToChanged(){
        if let selectedDate = orderDateToPicker?.date{
            orderTimeToPicker?.setDate(selectedDate, animated: true)
        }
    }
    
    private func setCurrentDate(){
        orderDateFromPicker?.setDate(Date(), animated: true)
        orderDateToPicker?.setDate(Date().addingTimeInterval(60*60*24), animated: true)
        orderTimeToPicker?.setDate(Date().addingTimeInterval(60*60*24*60*60), animated: true)
    }
    
    @objc private func setMinimumDate(){
        orderDateFromPicker?.minimumDate = Date()
        orderDateToPicker?.minimumDate = Date()
        orderTimeFromPicker?.minimumDate = Date()
        orderTimeToPicker?.minimumDate = Date()
    }
    
    
    
}
// MARK: Create Views
extension PublicRequestViewController{
    
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
        
        createImageContainer()
        
        createAddPhotoButton()
        createCreateOrderButton()
        
        title = "Оформить вызов"
        orderDateLabel?.text = "Дата вызова"
        orderTimeLabel?.text = "Время вызова"
        orderSumLabel?.text = "Сумма оплаты"
        phoneNumberLabel?.text = "Номер телефона"
        addressLabel?.text = "Адрес вызова"
        commentsLabel?.text = "Комментарии"
        
        addPhotoButton?.setTitle("Добавить фото", for: .normal)
        createOrderButton?.setTitle("Оформить", for: .normal)
        
        addPhotoButton?.addTarget(self, action: #selector(addPhotoButtonClick), for: .touchUpInside)
        createOrderButton?.addTarget(self, action: #selector(createPublicRequest), for: .touchUpInside)
        
        setCurrentDate()
        if let orderDateToPicker = orderDateToPicker{
            orderDateToPicker.addTarget(self, action: #selector(orderDateToChanged), for: .valueChanged)
        }
        setupViewsConstraints(to: scrollContentView)
    }
    
    private func setupViewsConstraints(to view: UIView){
        setupOrderDateConstraints(view: view)
        
        setupOrderTimeConstraints(view: view)
        
        setupOrderSumConstraints(view: view)
        
        setupPhoneNumberConstraints(view: view)
        
        setupAddressConstraints(view: view)
        
        setupCommentsConstraints(view: view)
        
        setupImageConstainerConstraints(view: view)
        
        setupAddPhotoButtonConstraints(view: view)
        setupCreateOrderButtonConstraints(view: view)
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
        
        if let commentsTextView = commentsTextView{
            imageContainer.topAnchor.constraint(equalTo: commentsTextView.bottomAnchor, constant: 10).isActive = true
        }

        NSLayoutConstraint.activate([
            imageContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            imageContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
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
        NSLayoutConstraint.activate([
            orderDateLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            orderDateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            
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
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.addSubview(stackView)
        imageContainer = stackView
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
        datePicker.minimumDate = Date()
        datePicker.contentHorizontalAlignment = .leading
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.addSubview(datePicker)
        orderTimeToPicker = datePicker
    }
    
    private func createOrderTimeFromTextField(){
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.minimumDate = Date()
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
        datePicker.minimumDate = Date()
        datePicker.contentHorizontalAlignment = .leading
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.addSubview(datePicker)
        orderDateToPicker = datePicker
    }
    
    private func createOrderDateFromPicker(){
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
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
    
    private func createTextField() -> UITextField{
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
