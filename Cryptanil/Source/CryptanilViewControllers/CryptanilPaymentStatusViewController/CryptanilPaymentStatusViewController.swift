//
//  PaymentStatusViewController.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 05.10.22.
//

import UIKit

final class CryptanilPaymentStatusViewController: UIViewController, CryptanilPaymentStatusViewDelegate {

    private var scrollView: UIScrollView!
    private var cryptanilPaymentStatusView: CryptanilPaymentStatusView!
    
    private var orderInfo: CryptanilOrderInfo
    private var orderKey: String
    private var timer: Timer?
    var presenting: Bool
    weak var delegate: CryptanilViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        if CryptanilOrderStatus(rawValue: orderInfo.status) == .submitted {
            timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
                self?.getOrderInfo()
            }
        }
        setupUI()
        cryptanilPaymentStatusView.setupInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cryptanilPaymentStatusView.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
    }
    
    init(orderInfo: CryptanilOrderInfo, orderKey: String, delegate: CryptanilViewControllerDelegate?, presenting: Bool) {
        self.orderInfo = orderInfo
        self.orderKey = orderKey
        self.presenting = presenting
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        view.backgroundColor = CryptanilColors.background
        navigationItem.title = "Transaction status".cryptanilLocalized()
        if presenting {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done".cryptanilLocalized(), style: .done, target: self, action: #selector(done))
        }
        setupScrollView()
        setupCryptanilPaymentView()
    }
    
    @objc private func done() {
        self.dismiss(animated: true)
    }
    
    @objc private func getOrderInfo() {
        CryptanilApiClient.getCryptanilOrderInfo(parameter: GetCryptanilOrderInfoRequest(auth: orderKey), isSilent: true) { orderInfo, message, error in 
            if let orderInfo = orderInfo {
                if CryptanilOrderStatus(rawValue: orderInfo.status) == .expired || CryptanilOrderStatus(rawValue: orderInfo.status) == .completed {
                    self.orderInfo = orderInfo
                    self.cryptanilPaymentStatusView.orderInfo = orderInfo
                    self.cryptanilPaymentStatusView.setupInfo()
                    self.timer?.invalidate()
                }
            }
        } cryptaninFailed: { error in
            self.delegate?.cryptanilTransactionFailed?(with: error)
            self.close()
        }
    }
    
    func doneTapped() {
        if presenting {
            self.dismiss(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func close() {
        if presenting {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func setupCryptanilPaymentView() {
        cryptanilPaymentStatusView = CryptanilPaymentStatusView(orderInfo: orderInfo)
        cryptanilPaymentStatusView.delegate = self
        scrollView.addSubview(cryptanilPaymentStatusView)
        cryptanilPaymentStatusView.translatesAutoresizingMaskIntoConstraints = false
        cryptanilPaymentStatusView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        cryptanilPaymentStatusView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
        cryptanilPaymentStatusView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20).isActive = true
        cryptanilPaymentStatusView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
        cryptanilPaymentStatusView.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
    }
}
