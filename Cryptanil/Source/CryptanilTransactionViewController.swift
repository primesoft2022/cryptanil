//
//  CryptanilViewController.swift
//  AFNetworking
//
//  Created by Hayk Movsesyan on 30.09.22.
//

import UIKit

final class CryptanilTransactionViewController: UIViewController {
    
    private var cryptoTypeTextField: CryptanilTextField!
    private var networkTextField: CryptanilTextField!
    private var addressTextField: CryptanilTextField!
    private var memoTextField: CryptanilTextField!
    private var txIDTextField: CryptanilTextField!
    private var addressStackView: UIStackView!
    private var addressQrCode: UIImageView!
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
            if let address = newValue {
                addressTextField.text = address
                addressQrCode.image = address.toCryptanilQrCode()
                addressStackView.isHidden = false
            } else {
                addressStackView.isHidden = true
            }
        }
    }
    private var memo: String = "" {
        willSet {
            memoTextField.isHidden = newValue.isEmpty
            memoTextField.text = newValue
        }
    }
    private var orderId: String
    var presenting: Bool
    weak var delegate: CryptanilViewControllerDelegate?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyboardNotifications()
        setupUI()
        getWalletInfo(convertedCoinType: orderInfo.convertedCoinType)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParentViewController {
            delegate?.cryptanilTransactionCanceled?()
        }
    }
    
    init(orderId: String, orderInfo: CryptanilOrderInfo, delegate: CryptanilViewControllerDelegate?, presenting: Bool) {
        self.orderId = orderId
        self.orderInfo = orderInfo
        self.presenting = presenting
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        view.backgroundColor = CryptanilColors.background
        setupNavigation()
        if presenting {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel".cryptanilLocalized(), style: .done, target: self, action: #selector(cancelTransaction))
        }
        setupScrollView()
        setupContentView()
        setupHeader()
        setupTextFields()
        setupSubmitButton()
    }
    
    private func setupNavigation() {
        let navigationView = UIView()
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        navigationView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        let iconView = UIImageView(image: CryptanilImages.logo)
        iconView.contentMode = .scaleAspectFit
        let titleLabel = UILabel()
        titleLabel.text = "Cryptanil"
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.numberOfLines = 0
        navigationView.addSubview(iconView)
        navigationView.addSubview(titleLabel)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor).isActive = true
        iconView.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: navigationView.trailingAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor).isActive = true
        navigationItem.titleView = navigationView
    }
    
    @objc private func cancelTransaction() {
        self.dismiss(animated: true)
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
    
    var iconView = UIImageView()
    
    private func setupHeader() {
        headerStackView = UIStackView()
        headerStackView.alignment = .center
        headerStackView.distribution = .fillProportionally
        headerStackView.axis = .horizontal
        headerStackView.spacing = 10
        contentView.addSubview(headerStackView)
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        headerStackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        headerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        headerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
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
        contentView.addSubview(textFieldsStackView)
        textFieldsStackView.translatesAutoresizingMaskIntoConstraints = false
        textFieldsStackView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 20).isActive = true
        textFieldsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        textFieldsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
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
        networkPicker = UIPickerView()
        let pickerHeight = networkPicker.frame.height + (UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0)
        networkPicker.frame.size = CGSize(width: view.frame.width, height: pickerHeight)
        networkTextField.tintColor = .clear
        networkTextField.textField?.inputView = networkPicker
        networkPicker.delegate = self
        networkPicker.dataSource = self
        let toolBar = UIToolbar()
        toolBar.frame.size = CGSize(width: view.frame.width, height: 40)
        toolBar.sizeToFit()
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolBar.setItems([cancelButton, space, doneButton], animated: false)
        networkTextField.textField?.inputAccessoryView = toolBar
    }
    
    @objc func cancel() {
        view.endEditing(true)
        delegate?.cryptanilTransactionCanceled?()
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
        submitButton.backgroundColor = CryptanilColors.blue
        submitButton.setTitle("Submit".cryptanilLocalized(), for: .normal)
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
        view.endEditing(true)
        let submitOrderRequest = SubmitOrderRequest(txId: txIDTextField.text, auth: orderId)
        CryptanilApiClient.submitOrder(body: submitOrderRequest) { orderInfo, message, error in
            if let orderInfo = orderInfo, let status = CryptanilOrderStatus(rawValue: orderInfo.status) {
                self.delegate?.cryptanilTransactionChanged(to: status, for: orderInfo)
                let vc = CryptanilPaymentStatusViewController(orderInfo: orderInfo, orderId: self.orderId, delegate: self.delegate, presenting: self.presenting)
                var viewControllers = self.navigationController?.viewControllers ?? []
                viewControllers.removeAll(where: {$0 == self})
                viewControllers.append(vc)
                self.navigationController?.setViewControllers(viewControllers, animated: true)
            } else if let error = error {
                self.delegate?.cryptanilTransactionFailed?(with: error)
            }
        } cryptaninFailed: { error in
            self.delegate?.cryptanilTransactionFailed?(with: error)
            self.close()
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
        CryptanilApiClient.getWalletInfo(parameter: GetWalletInfoRequest(auth: orderId)) { walletInfo, message, error in
            if let walletInfo = walletInfo {
                self.wallets = walletInfo
                self.selectedWallet = self.wallets.first(where: {$0.coin == convertedCoinType})
                if self.selectedNetwork != nil {
                    self.getCoinAddresses()
                }
            } else if let error = error {
                self.delegate?.cryptanilTransactionFailed?(with: error)
            }
        } cryptaninFailed: { error in
            self.delegate?.cryptanilTransactionFailed?(with: error)
            self.close()
        }
    }

    func getCoinAddresses() {
        if let coin = selectedWallet?.coin, let network = selectedNetwork?.network {
            CryptanilApiClient.getCoinAddress(parameter: GetCoinAddressRequest(auth: orderId, coin: coin, network: network)) { coinAddress, message, error in
                if let coinAddress = coinAddress {
                    self.address = coinAddress.address
                    self.memo = coinAddress.tag
                } else {
                    self.selectedWallet = self.wallets.first(where: {$0.coin.uppercased() == "usdt"})
                    self.getCoinAddresses()
                }
            } cryptaninFailed: { error in
                self.delegate?.cryptanilTransactionFailed?(with: error)
                self.close()
            }
        }
    }
    
    func close() {
        if presenting {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}

extension CryptanilTransactionViewController {
    
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
        scrollView.verticalScrollIndicatorInsets = contentInset
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        scrollView.verticalScrollIndicatorInsets = contentInset
    }
}

extension CryptanilTransactionViewController: CryptanilSearchViewControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func selected(wallet: WalletInfo) {
        selectedWallet = wallet
        getCoinAddresses()
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == cryptoTypeTextField.textField {
            let vc = CryptanilSearchViewController()
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
