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
    
    private var orderKey: String
    public weak var delegate: CryptanilViewControllerDelegate?
    private var presenting: Bool {
        return presentingViewController != nil
    }
    public var language: CryptanilLanguage = .en {
        willSet {
            CryptanilLanguage.current = newValue
        }
    }
    
    public init(orderKey: String) {
        self.orderKey = orderKey
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    public init(orderKey: String, delegate: CryptanilViewControllerDelegate) {
        self.orderKey = orderKey
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
        let spashVC = CryptanilSplashViewController(orderKey: orderKey, delegate: delegate)
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
        let cryptanilView = CryptanilView()
        view.addSubview(cryptanilView)
        cryptanilView.translatesAutoresizingMaskIntoConstraints = false
        cryptanilView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        cryptanilView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cryptanilView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
}
