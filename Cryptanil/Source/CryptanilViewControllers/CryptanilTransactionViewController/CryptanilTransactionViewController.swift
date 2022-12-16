//
//  CryptanilViewController.swift
//  AFNetworking
//
//  Created by Hayk Movsesyan on 30.09.22.
//

import UIKit

final class CryptanilTransactionViewController: UIViewController {
    
    private var scrollView: UIScrollView!
    private var cryptanilTransactionView: CryptanilTransactionView!
    
    var orderInfo: CryptanilOrderInfo!
    private var orderKey: String
    var presenting: Bool
    weak var delegate: CryptanilViewControllerDelegate?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyboardNotifications()
        setupUI()
        getWalletInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cryptanilTransactionView.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParentViewController {
            delegate?.cryptanilTransactionCanceled?()
        }
    }
    
    init(orderKey: String, orderInfo: CryptanilOrderInfo, delegate: CryptanilViewControllerDelegate?, presenting: Bool) {
        self.orderKey = orderKey
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
        cryptanilTransactionView = CryptanilTransactionView()
        cryptanilTransactionView.orderInfo = orderInfo
        cryptanilTransactionView.delegate = self
        scrollView.addSubview(cryptanilTransactionView)
        cryptanilTransactionView.translatesAutoresizingMaskIntoConstraints = false
        cryptanilTransactionView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        cryptanilTransactionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
        cryptanilTransactionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20).isActive = true
        cryptanilTransactionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
        cryptanilTransactionView.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
    }
    
    
    func getWalletInfo() {
        CryptanilApiClient.getWalletInfo(parameter: GetWalletInfoRequest(auth: orderKey)) { walletInfoResponse, message, error in
            if let walletInfoResponse = walletInfoResponse {
                self.cryptanilTransactionView.initialSetup(for: walletInfoResponse)
            } else if let error = error {
                self.delegate?.cryptanilTransactionFailed?(with: error)
            }
        } cryptaninFailed: { error in
            self.delegate?.cryptanilTransactionFailed?(with: error)
            self.close()
        }
    }

    func getCoinAddresses() {
        if let coin = cryptanilTransactionView.selectedWallet?.coin,
           let network = cryptanilTransactionView.selectedNetwork?.network {
            CryptanilApiClient.getCoinAddress(parameter: GetCoinAddressRequest(auth: orderKey, coin: coin, network: network)) { coinAddress, message, error in
                self.cryptanilTransactionView.setup(for: coinAddress)
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

extension CryptanilTransactionViewController: CryptanilSearchViewControllerDelegate, CryptanilTransactionViewDelegate {
    
    func openSearchController(for wallets: [WalletInfo]) {
        let vc = CryptanilSearchViewController()
        vc.wallets = wallets
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    func selected(wallet: WalletInfo) {
        cryptanilTransactionView.selectedWallet = wallet
        getCoinAddresses()
    }
    
    func submit(for txId: String) {
        let submitOrderRequest = SubmitOrderRequest(txId: txId, auth: orderKey)
        CryptanilApiClient.submitOrder(body: submitOrderRequest) { orderInfo, message, error in
            if let orderInfo = orderInfo, let status = CryptanilOrderStatus(rawValue: orderInfo.status) {
                self.delegate?.cryptanilTransactionChanged(to: status, for: orderInfo)
                let vc = CryptanilPaymentStatusViewController(orderInfo: orderInfo, orderKey: self.orderKey, delegate: self.delegate, presenting: self.presenting)
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
}
