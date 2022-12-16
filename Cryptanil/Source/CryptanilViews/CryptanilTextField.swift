//
//  CryptanilTextField.swift
//  AFNetworking
//
//  Created by Hayk Movsesyan on 30.09.22.
//

import UIKit

class CryptanilTextField: UIView {
    
    private var placeholderLabel: UILabel!
    var textField: UITextField!
    private var button: UIButton!
    private var placeholder: String!
    private var buttonText: String?
    private var showArrow: Bool = true
    var text: String {
        get {
            return textField?.text ?? ""
        }
        set {
            textField?.text = newValue
        }
    }
    var delegate: UITextFieldDelegate? {
        get {
            return textField.delegate
        }
        set {
            textField.delegate = newValue
        }
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
    }
    
    func setup(placeholder: String, text: String, buttonText: String?, showArrow: Bool) {
        self.placeholder = placeholder
        self.text = text
        self.showArrow = showArrow
        self.buttonText = buttonText
        setupView()
    }
    
    override func disable() {
        textField.isUserInteractionEnabled = false
        textField.alpha = 0.6
    }
    
    override func enable() {
        textField.isUserInteractionEnabled = true
        textField.alpha = 1
    }
    
    private func setupView() {
        addPaceholder()
        addTextField()
        addCopyButton()
    }
    
    private func addPaceholder() {
        placeholderLabel = UILabel()
        addSubview(placeholderLabel)
        placeholderLabel.textColor = CryptanilColors.black
        placeholderLabel.font = UIFont.systemFont(ofSize: 14)
        placeholderLabel.text = placeholder
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        placeholderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        placeholderLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    private func addTextField() {
        textField = UITextField()
        addSubview(textField)
        textField.text = text
        textField.textColor = CryptanilColors.black
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = CryptanilColors.gray.cgColor
        textField.backgroundColor = CryptanilColors.inputBackground
        textField.layer.borderWidth = 1
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        textField.leftViewMode = .always
        textField.font = UIFont.systemFont(ofSize: 14)
        if showArrow {
            let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 0))
            let arrowImageView = UIImageView()
            let image = UIImage(systemName: "chevron.down")
            arrowImageView.image = image
            arrowImageView.contentMode = .center
            arrowImageView.tintColor = CryptanilColors.black
            arrowImageView.center = rightView.center
            rightView.addSubview(arrowImageView)
            rightView.isUserInteractionEnabled = false
            textField.rightView = rightView
            textField.rightViewMode = .always
        } else {
            textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
            textField.rightViewMode = .always
        }
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.topAnchor.constraint(equalTo: placeholderLabel.bottomAnchor, constant: 5).isActive = true
        textField.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }

    private func addCopyButton() {
        if let text = buttonText {
            button = UIButton()
            let atributedText = NSAttributedString(string: text, attributes: [.underlineColor: CryptanilColors.blue, .underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
            button.setAttributedTitle(atributedText, for: .normal)
            button.setTitleColor(CryptanilColors.blue, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 5).isActive = true
            button.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor).isActive = true
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
    }
    
    @objc private func buttonTapped() {
        UIPasteboard.general.string = text
        CryptanilTopMessage.show(message: "Copied !")
    }
}

