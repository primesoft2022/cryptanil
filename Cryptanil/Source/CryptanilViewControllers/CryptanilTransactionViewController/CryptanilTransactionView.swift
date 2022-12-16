//
//  CryptanilTransactionView.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 16.12.22.
//

import UIKit

protocol CryptanilTransactionViewDelegate: AnyObject {
    func openSearchController(for wallets: [WalletInfo])
    func submit(for txId: String)
    func getCoinAddresses()
}

class CryptanilTransactionView: UIView {
    
    var cryptoTypeTextField: CryptanilTextField!
    var networkTextField: CryptanilTextField!
    var addressTextField: CryptanilTextField!
    var memoTextField: CryptanilTextField!
    var txIDTextField: CryptanilTextField!
    var addressStackView: UIStackView!
    var addressQrCode: UIImageView!
    private var headerStackView: UIStackView!
    private var textFieldsStackView: UIStackView!
    var submitButton: UIButton!
    var networkPicker: UIPickerView!
    var iconView = UIImageView()
    
    var orderInfo: CryptanilOrderInfo!
    var wallets: [WalletInfo] = []
    var selectedWallet: WalletInfo? {
        willSet {
            cryptoTypeTextField.text = newValue?.coin ?? ""
            coinNetworks = newValue?.networkList ?? []
        }
    }
    var coinNetworks: [Network] = [] {
        willSet {
            selectedNetwork = newValue.first(where: {$0.isDefault}) ?? newValue.first
            if newValue.count <= 1 {
                networkTextField.disable()
            } else {
                networkTextField.enable()
            }
        }
    }
    var selectedNetwork: Network? {
        willSet {
            networkTextField.text = newValue?.name ?? ""
        }
    }
    var address: String? {
        willSet {
            if let address = newValue {
                addressTextField.text = address
                addressQrCode.image = address.toCryptanilQrCode()
                addressStackView.isHidden = false
            } else {
                addressStackView.isHidden = true
            }
        }
    }
    var memo: String = "" {
        willSet {
            memoTextField.isHidden = newValue.isEmpty
            memoTextField.text = newValue
        }
    }
    
    weak var delegate: CryptanilTransactionViewDelegate?

    init() {
        super.init(frame: .zero)
        setupHeader()
        setupTextFields()
        setupSubmitButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialSetup(for walletInfo: WalletInfoResponse) {
        wallets = walletInfo.coins
        selectedWallet = wallets.first(where: {$0.coin == walletInfo.defaultCoin})
        selectedNetwork = coinNetworks.first(where: {$0.network == walletInfo.defaultNetwork}) ?? coinNetworks.first(where: {$0.isDefault})
        if selectedNetwork != nil {
            delegate?.getCoinAddresses()
        }
    }
    
    
    func setup(for coinAddress: CoinAddress?) {
        if let coinAddress = coinAddress {
            address = coinAddress.address
            memo = coinAddress.tag
        } else {
            selectedWallet = wallets.first(where: {$0.coin.uppercased() == "usdt"})
            delegate?.getCoinAddresses()
        }
    }
    
    private func setupHeader() {
        headerStackView = UIStackView()
        headerStackView.alignment = .center
        headerStackView.distribution = .fillProportionally
        headerStackView.axis = .horizontal
        headerStackView.spacing = 10
        addSubview(headerStackView)
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        headerStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        headerStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        headerStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        iconView = UIImageView()
        iconView.image = CryptanilImages.warning
        iconView.contentMode = .scaleAspectFit
        headerStackView.addArrangedSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        let headerTitle = UILabel()
        headerTitle.text = "Please don't pay by Binance Pay. Because we can't see that transaction in our system, your transaction may not be complete.".cryptanilLocalized()
        headerTitle.textColor = CryptanilColors.yellow
        headerTitle.numberOfLines = 0
        headerTitle.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        headerStackView.addArrangedSubview(headerTitle)
    }
    
    private func setupTextFields() {
        textFieldsStackView = UIStackView()
        textFieldsStackView.alignment = .fill
        textFieldsStackView.distribution = .equalSpacing
        textFieldsStackView.axis = .vertical
        addSubview(textFieldsStackView)
        textFieldsStackView.translatesAutoresizingMaskIntoConstraints = false
        textFieldsStackView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 20).isActive = true
        textFieldsStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        textFieldsStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        cryptoTypeTextField = textField(placeholder: "Crypto type".cryptanilLocalized(), showArrow: true)
        networkTextField = textField(placeholder: "Network".cryptanilLocalized(), showArrow: true)
        addressTextField = textField(placeholder: "Address".cryptanilLocalized(), buttonText: "copy address".cryptanilLocalized())
        memoTextField = textField(placeholder: "Memo".cryptanilLocalized(), buttonText: "copy memo".cryptanilLocalized())
        txIDTextField = textField(placeholder: "TxID".cryptanilLocalized())
        addressTextField.disable()
        memoTextField.disable()
        memoTextField.isHidden = true
        memoTextField.textField.isUserInteractionEnabled = false
        addressTextField.textField.isUserInteractionEnabled = false
        addressStackView = UIStackView()
        addressStackView.alignment = .fill
        addressStackView.distribution = .fillProportionally
        addressStackView.axis = .horizontal
        addressStackView.spacing = 10
        addressStackView.isHidden = true
        addressQrCode = UIImageView()
        addressStackView.addArrangedSubview(addressTextField)
        addressStackView.addArrangedSubview(addressQrCode)
        textFieldsStackView.addArrangedSubview(cryptoTypeTextField)
        textFieldsStackView.addArrangedSubview(networkTextField)
        textFieldsStackView.addArrangedSubview(addressStackView)
        textFieldsStackView.addArrangedSubview(memoTextField)
        textFieldsStackView.addArrangedSubview(txIDTextField)
        addressQrCode.translatesAutoresizingMaskIntoConstraints = false
        addressQrCode.widthAnchor.constraint(equalToConstant: 100).isActive = true
        setupPicker()
    }
    
    func setupPicker() {
        let windowFrame = UIApplication.shared.windows.first?.frame ?? self.frame
        networkPicker = UIPickerView()
        let pickerHeight = networkPicker.frame.height + (UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0)
        networkPicker.frame.size = CGSize(width: windowFrame.width, height: pickerHeight)
        networkTextField.tintColor = .clear
        networkTextField.textField?.inputView = networkPicker
        networkPicker.delegate = self
        networkPicker.dataSource = self
        let toolBar = UIToolbar()
        toolBar.frame.size = CGSize(width: windowFrame.width, height: 40)
        toolBar.sizeToFit()
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolBar.setItems([cancelButton, space, doneButton], animated: false)
        networkTextField.textField?.inputAccessoryView = toolBar
    }
    
    @objc func cancel() {
        endEditing(true)
    }
    
    @objc func done() {
        let index = networkPicker.selectedRow(inComponent: 0)
        if coinNetworks.count > index {
            selectedNetwork = coinNetworks[index]
            delegate?.getCoinAddresses()
        }
        endEditing(true)
    }
    
    private func setupSubmitButton() {
        submitButton = UIButton()
        submitButton.disable()
        submitButton.backgroundColor = CryptanilColors.blue
        submitButton.setTitle("Submit".cryptanilLocalized(), for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 10
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        addSubview(submitButton)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        submitButton.topAnchor.constraint(equalTo: textFieldsStackView.bottomAnchor, constant: 10).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        submitButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    @objc private func submitTapped() {
        endEditing(true)
        delegate?.submit(for: txIDTextField.text)
    }
    
    func textField(placeholder: String, text: String = "", buttonText: String? = nil, showArrow: Bool = false) -> CryptanilTextField {
        let textField = CryptanilTextField()
        textField.setup(placeholder: placeholder, text: text, buttonText: buttonText, showArrow: showArrow)
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 100).isActive = true
        textField.delegate = self
        return textField
    }
}


extension CryptanilTransactionView: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == cryptoTypeTextField.textField {
            delegate?.openSearchController(for: wallets)
            return false
        }
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
        if newString.count >= 5 {
            submitButton.enable()
        } else {
            submitButton.disable()
        }
        return textField == txIDTextField.textField
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinNetworks.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinNetworks[row].name
    }
}
