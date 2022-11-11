//
//  CryptanilViewController.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 11.11.22.
//

import Foundation

@objc public protocol CryptanilViewControllerDelegate: class {
    func cryptanilTransactionChanged(to status: CryptanilOrderStatus, for orderInfo: CryptanilOrderInfo)
    @objc optional func cryptanilTransactionFailed(with error: CryptanilError)
    @objc optional func cryptanilTransactionCanceled()
}

public class CryptanilViewController: UIViewController {
    
    private var orderId: String
    public weak var delegate: CryptanilViewControllerDelegate?
    private var presenting: Bool {
        return presentingViewController != nil
    }
    public var language: CryptanilLanguage = .en {
        willSet {
            CryptanilLanguage.current = newValue
        }
    }
    
    public init(orderId: String) {
        self.orderId = orderId
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    public init(orderId: String, delegate: CryptanilViewControllerDelegate) {
        self.orderId = orderId
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigation()
    }
    
    private func setupNavigation() {
        let spashVC = CryptanilSplashViewController(orderId: orderId, delegate: delegate)
        if presenting {
            let navigation = UINavigationController(rootViewController: spashVC)
            self.addChildViewController(navigation)
            navigation.view.frame = view.bounds
            navigation.isNavigationBarHidden = true
            view.addSubview(navigation.view)
        } else {
            var viewControllers = self.navigationController?.viewControllers ?? []
            viewControllers.removeAll(where: {$0 == self})
            viewControllers.append(spashVC)
            self.navigationController?.setViewControllers(viewControllers, animated: false)
        }
    }
    
    private func setupUI() {
        view.backgroundColor = CryptanilColors.background
        navigationController?.isNavigationBarHidden = true
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
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
}
