//
//  CryptanilViewController.swift
//  AFNetworking
//
//  Created by Hayk Movsesyan on 30.09.22.
//

import UIKit

final class TransactionViewController: UIViewController {
    
    private var cryptoTypeTextField: CryptanilTextField!
    private var networkTextField: CryptanilTextField!
    private var addressTextField: CryptanilTextField!
    private var memoTextField: CryptanilTextField!
    private var txIDTextField: CryptanilTextField!
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var headerStackView: UIStackView!
    private var textFieldsStackView: UIStackView!
    private var submitButton: UIButton!
    private var networkPicker: UIPickerView!
    
    private var orderInfo: CryptanilOrderInfo!
    private var wallets: [WalletInfo] = []
    private var selectedWallet: WalletInfo? {
        willSet {
            cryptoTypeTextField.text = newValue?.coin ?? ""
            coinNetworks = newValue?.networkList ?? []
        }
    }
    private var coinNetworks: [Network] = [] {
        willSet {
            selectedNetwork = newValue.first(where: {$0.isDefault}) ?? newValue.first
            if newValue.count <= 1 {
                networkTextField.disable()
            } else {
                networkTextField.enable()
            }
        }
    }
    private var selectedNetwork: Network? {
        willSet {
            networkTextField.text = newValue?.name ?? ""
        }
    }
    private var address: String? {
        willSet {
            addressTextField.text = newValue ?? ""
        }
    }
    private var memo: String = "" {
        willSet {
            memoTextField.isHidden = newValue.isEmpty
            memoTextField.text = newValue
        }
    }
    private var id = "bfc73d31-8132-4f03-a05f-9cfc119ff89b"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerKeyboardNotifications()
        getWalletInfo(convertedCoinType: orderInfo.convertedCoinType)
    }
    
    public init(id: String, orderInfo: CryptanilOrderInfo) {
        self.id = id
        self.orderInfo = orderInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        view.backgroundColor = Colors.background
        navigationItem.title = "Transaction"
        setupScrollView()
        setupContentView()
        setupHeader()
        setupTextFields()
        setupSubmitButton()
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }
    
    private func setupContentView() {
        contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
        contentView.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
    }
    
    private func setupHeader() {
        headerStackView = UIStackView()
        headerStackView.alignment = .center
        headerStackView.distribution = .fillProportionally
        headerStackView.axis = .horizontal
        headerStackView.spacing = 20
        contentView.addSubview(headerStackView)
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        headerStackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        headerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        headerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        headerStackView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        let iconView = UIImageView()
        iconView.image = Images.logo
        iconView.contentMode = .scaleAspectFit
        headerStackView.addArrangedSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        let headerTitle = UILabel()
        headerTitle.text = "Cryptanil Address to which trnsaction should be made"
        headerTitle.textColor = Colors.black
        headerTitle.numberOfLines = 0
        headerTitle.font = UIFont.systemFont(ofSize: 14)
        headerStackView.addArrangedSubview(headerTitle)
    }
    
    private func setupTextFields() {
        textFieldsStackView = UIStackView()
        textFieldsStackView.alignment = .fill
        textFieldsStackView.distribution = .equalSpacing
        textFieldsStackView.axis = .vertical
        contentView.addSubview(textFieldsStackView)
        textFieldsStackView.translatesAutoresizingMaskIntoConstraints = false
        textFieldsStackView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 20).isActive = true
        textFieldsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        textFieldsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        cryptoTypeTextField = textField(placeholder: "Crypto type", showArrow: true)
        networkTextField = textField(placeholder: "Network", showArrow: true)
        addressTextField = textField(placeholder: "Address", buttonText: "copy address")
        memoTextField = textField(placeholder: "Memo", buttonText: "copy memo")
        txIDTextField = textField(placeholder: "TxID")
        memoTextField.isHidden = true
        memoTextField.textField.isUserInteractionEnabled = false
        addressTextField.textField.isUserInteractionEnabled = false
        textFieldsStackView.addArrangedSubview(cryptoTypeTextField)
        textFieldsStackView.addArrangedSubview(networkTextField)
        textFieldsStackView.addArrangedSubview(addressTextField)
        textFieldsStackView.addArrangedSubview(memoTextField)
        textFieldsStackView.addArrangedSubview(txIDTextField)
        setupPicker()
    }
    
    func setupPicker() {
        networkPicker = UIPickerView()
        networkTextField.tintColor = .clear
        networkTextField.textField?.inputView = networkPicker
        networkPicker.delegate = self
        networkPicker.dataSource = self
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolBar.setItems([cancelButton, space, doneButton], animated: false)
        networkTextField.textField?.inputAccessoryView = toolBar
    }
    
    @objc func cancel() {
        view.endEditing(true)
    }
    
    @objc func done() {
        let index = networkPicker.selectedRow(inComponent: 0)
        if coinNetworks.count > index {
            selectedNetwork = coinNetworks[index]
            getCoinAddresses()
        }
        view.endEditing(true)
    }
    
    private func setupSubmitButton() {
        submitButton = UIButton()
        submitButton.disable()
        submitButton.backgroundColor = Colors.blue
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 10
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        contentView.addSubview(submitButton)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        submitButton.topAnchor.constraint(equalTo: textFieldsStackView.bottomAnchor, constant: 10).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        submitButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    @objc private func submitTapped() {
        let submitOrderRequest = SubmitOrderRequest(txId: txIDTextField.text, auth: id)
        ApiClient.submitOrder(body: submitOrderRequest) { submitOrderResponse, message, error in
            if let submitOrderResponse = submitOrderResponse {
                let vc = PaymentStatusViewController(orderInfo: submitOrderResponse)
                var viewControllers = self.navigationController?.viewControllers ?? []
                viewControllers.removeAll(where: {$0 == self})
                viewControllers.append(vc)
                self.navigationController?.setViewControllers(viewControllers, animated: true)
            }
        }
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
    
    func getWalletInfo(convertedCoinType: String) {
        ApiClient.getWalletInfo(parameter: GetWalletInfoRequest(auth: id)) { walletInfo, message, error in
            if let walletInfo = walletInfo {
                self.wallets = walletInfo
                self.selectedWallet = self.wallets.first(where: {$0.coin == convertedCoinType})
                if self.selectedNetwork != nil {
                    self.getCoinAddresses()
                }
            }
        }
    }

    func getCoinAddresses() {
        if let coin = selectedWallet?.coin, let network = selectedNetwork?.network {
            ApiClient.getCoinAddress(parameter: GetCoinAddressRequest(auth: id, coin: coin, network: network)) { coinAddress, message, error in
                if let coinAddress = coinAddress {
                    self.address = coinAddress.address
                    self.memo = coinAddress.tag
                } else {
                    self.selectedWallet = self.wallets.first(where: {$0.coin.uppercased() == "usdt"})
                    self.getCoinAddresses()
                }
            }
        }
    }
}

extension TransactionViewController {
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame: CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        var contentInset: UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height - view.safeAreaInsets.bottom
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
}

extension TransactionViewController: SearchViewControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func selected(wallet: WalletInfo) {
        selectedWallet = wallet
        getCoinAddresses()
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == cryptoTypeTextField.textField {
            let vc = SearchViewController()
            vc.wallets = wallets
            vc.delegate = self
            self.present(vc, animated: true)
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
