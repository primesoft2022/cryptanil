//
//  CryptanilViewController.swift
//  AFNetworking
//
//  Created by Hayk Movsesyan on 30.09.22.
//

import UIKit

public final class CryptanilViewController: UIViewController, UITextFieldDelegate {
    
    private var cryptoTypeTextField: CryptanilTextField!
    private var networkTextField: CryptanilTextField!
    private var addressTextField: CryptanilTextField!
    private var memoTextField: CryptanilTextField!
    private var txIDTextField: CryptanilTextField!
        
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.layoutIfNeeded()
        view.backgroundColor = Colors.background
        let scrollView = UIScrollView()
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        let contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        let headerStack = UIStackView()
        headerStack.alignment = .center
        headerStack.distribution = .fillProportionally
        headerStack.axis = .horizontal
        headerStack.spacing = 20
        contentView.addSubview(headerStack)
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        headerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30).isActive = true
        headerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        headerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        headerStack.heightAnchor.constraint(equalToConstant: 60).isActive = true
        let iconView = UIImageView()
        iconView.image = Images.logo
        iconView.contentMode = .scaleAspectFit
        headerStack.addArrangedSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        let headerTitle = UILabel()
        headerTitle.text = "Cryptanil Address to which trnsaction should be made"
        headerTitle.textColor = Colors.black
        headerTitle.numberOfLines = 0
        headerStack.addArrangedSubview(headerTitle)
        let textFieldsStackView = UIStackView()
        textFieldsStackView.alignment = .fill
        textFieldsStackView.distribution = .equalSpacing
        textFieldsStackView.axis = .vertical
        contentView.addSubview(textFieldsStackView)
        textFieldsStackView.translatesAutoresizingMaskIntoConstraints = false
        textFieldsStackView.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 20).isActive = true
        textFieldsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        textFieldsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        cryptoTypeTextField = textField(placeholder: "Crypto type", showArrow: true)
        networkTextField = textField(placeholder: "Network", showArrow: true)
        addressTextField = textField(placeholder: "Address", buttonText: "copy address")
        memoTextField = textField(placeholder: "Memo", buttonText: "copy memo")
        txIDTextField = textField(placeholder: "TxID")
        textFieldsStackView.addArrangedSubview(cryptoTypeTextField)
        textFieldsStackView.addArrangedSubview(networkTextField)
        textFieldsStackView.addArrangedSubview(addressTextField)
        textFieldsStackView.addArrangedSubview(memoTextField)
        textFieldsStackView.addArrangedSubview(txIDTextField)
        let submitButton = UIButton()
        submitButton.backgroundColor = Colors.blue
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 10
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(submitButton)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        submitButton.topAnchor.constraint(equalTo: textFieldsStackView.bottomAnchor, constant: 10).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        submitButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    func textField(placeholder: String, text: String = "", buttonText: String? = nil, showArrow: Bool = false) -> CryptanilTextField {
        let textField = CryptanilTextField()
        textField.setup(placeholder: placeholder, text: text, buttonText: buttonText, showArrow: showArrow)
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 100).isActive = true
        textField.delegate = self
        return textField
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }
}
