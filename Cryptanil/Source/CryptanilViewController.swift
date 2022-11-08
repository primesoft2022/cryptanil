//
//  CryptanilViewController.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 06.10.22.
//

import UIKit

public protocol CryptanilViewControllerDelegate: AnyObject {
    func cryptanilTransactionChanged(to status: CryptanilOrderStatus, for orderInfo: CryptanilOrderInfo)
    func cryptanilTransactionFailed(with error: CryptanilError)
    func cryptanilTransactionCanceled()
}

public class CryptanilViewController: UIViewController {
    
    private var id: String
    public weak var delegate: CryptanilViewControllerDelegate?
    private var presenting: Bool {
        return presentingViewController != nil && navigationController?.viewControllers == [self]
    }
    public var language: CryptanilLanguage = .en {
        willSet {
            CryptanilLanguage.current = newValue
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if !presenting {
            getCryptaneilOrderInfo()
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if presenting {
            getCryptaneilOrderInfo()
        }
    }
    
    public init(id: String) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    public init(id: String, delegate: CryptanilViewControllerDelegate) {
        self.id = id
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        view.backgroundColor = CryptanilColors.background
        navigationController?.navigationBar.isHidden = true
        let contentView = UIView()
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        let iconView = UIImageView()
        iconView.image = CryptanilImages.logo
        contentView.addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        iconView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        let cryptalinLabel = UILabel()
        cryptalinLabel.text = "Cryptanil"
        cryptalinLabel.font = UIFont.systemFont(ofSize: 24)
        cryptalinLabel.textColor = CryptanilColors.black
        cryptalinLabel.textAlignment = .center
        contentView.addSubview(cryptalinLabel)
        cryptalinLabel.translatesAutoresizingMaskIntoConstraints = false
        cryptalinLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 20).isActive = true
        cryptalinLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        cryptalinLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        cryptalinLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func getCryptaneilOrderInfo() {
        CryptanilApiClient.getCryptanilOrderInfo(parameter: GetCryptanilOrderInfoRequest(auth: id)) { orderInfo, message, error in
            if let orderInfo = orderInfo, let orderStatus = CryptanilOrderStatus(rawValue: orderInfo.status) {
                self.delegate?.cryptanilTransactionChanged(to: orderStatus, for: orderInfo)
                var vc: UIViewController!
                if orderStatus == .created {
                    vc = CryptanilTransactionViewController(id: self.id, orderInfo: orderInfo, delegate: self.delegate, presenting: self.presenting)
                } else {
                    vc = CryptanilPaymentStatusViewController(orderInfo: orderInfo, id: self.id, delegate: self.delegate, presenting: self.presenting)
                }
                var viewControllers = self.navigationController?.viewControllers ?? []
                viewControllers.removeAll(where: {$0 == self})
                viewControllers.append(vc)
                self.navigationController?.setViewControllers(viewControllers, animated: true)
            }
        } cryptaninFailed: { error in
            self.delegate?.cryptanilTransactionFailed(with: error)
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
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
}
