//
//  CryptanilViewController.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 06.10.22.
//

import UIKit

class CryptanilSplashViewController: UIViewController {
   
    private var orderKey: String
    private weak var delegate: CryptanilViewControllerDelegate?
    private var presenting: Bool {
        return presentingViewController != nil && navigationController?.viewControllers == [self]
    }
    private var language: CryptanilLanguage = .en {
        willSet {
            CryptanilLanguage.current = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if !presenting {
            getCryptaneilOrderInfo()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if presenting {
            getCryptaneilOrderInfo()
        }
    }
    
    init(orderKey: String, delegate: CryptanilViewControllerDelegate?) {
        self.orderKey = orderKey
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        view.backgroundColor = CryptanilColors.background
        navigationController?.isNavigationBarHidden = true
        let cryptanilSplashView = CryptanilSplashView()
        view.addSubview(cryptanilSplashView)
        cryptanilSplashView.translatesAutoresizingMaskIntoConstraints = false
        cryptanilSplashView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        cryptanilSplashView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cryptanilSplashView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
    }
    
    func getCryptaneilOrderInfo() {
        CryptanilApiClient.getCryptanilOrderInfo(parameter: GetCryptanilOrderInfoRequest(auth: orderKey)) { orderInfo, message, error in
            if let orderInfo = orderInfo, let orderStatus = CryptanilOrderStatus(rawValue: orderInfo.status) {
                self.delegate?.cryptanilTransactionChanged(to: orderStatus, for: orderInfo)
                var vc: UIViewController!
                if orderStatus == .created {
                    vc = CryptanilTransactionViewController(orderKey: self.orderKey, orderInfo: orderInfo, delegate: self.delegate, presenting: self.presenting)
                } else {
                    vc = CryptanilPaymentStatusViewController(orderInfo: orderInfo, orderKey: self.orderKey, delegate: self.delegate, presenting: self.presenting)
                }
                var viewControllers = self.navigationController?.viewControllers ?? []
                viewControllers.removeAll(where: {$0 == self})
                viewControllers.append(vc)
                self.navigationController?.setViewControllers(viewControllers, animated: true)
            }
        } cryptaninFailed: { error in
            self.delegate?.cryptanilTransactionFailed?(with: error)
            self.close()
        }
    }
    
    func close() {
        if presenting {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
}
