//
//  CryptanilViewController.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 06.10.22.
//

import UIKit

public class CryptanilViewController: UIViewController {
    
    private var id = "bfc73d31-8132-4f03-a05f-9cfc119ff89b"

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getCryptaneilOrderInfo()
    }
    
    convenience init() {
        self.init(id: "")
    }
    
    public init(id: String) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        view.backgroundColor = Colors.background
        navigationController?.navigationBar.isHidden = true
        let contentView = UIView()
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        let iconView = UIImageView()
        iconView.image = Images.logo
        contentView.addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        iconView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        let cryptalinLabel = UILabel()
        cryptalinLabel.text = "Cryptanil"
        cryptalinLabel.font = UIFont.systemFont(ofSize: 24)
        cryptalinLabel.textColor = Colors.black
        cryptalinLabel.textAlignment = .center
        contentView.addSubview(cryptalinLabel)
        cryptalinLabel.translatesAutoresizingMaskIntoConstraints = false
        cryptalinLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 20).isActive = true
        cryptalinLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        cryptalinLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        cryptalinLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func getCryptaneilOrderInfo() {
        ApiClient.getCryptanilOrderInfo(parameter: GetCryptanilOrderInfoRequest(auth: id)) { orderInfo, message, error in
            if let orderInfo = orderInfo {
                if orderInfo.status == OrderStatuses.created.rawValue {
                    let vc = TransactionViewController(id: self.id, orderInfo: orderInfo)
                    var viewControllers = self.navigationController?.viewControllers ?? []
                    viewControllers.removeAll(where: {$0 == self})
                    viewControllers.append(vc)
                    self.navigationController?.setViewControllers(viewControllers, animated: true)
                } else {
                    let vc = PaymentStatusViewController(orderInfo: orderInfo)
                    var viewControllers = self.navigationController?.viewControllers ?? []
                    viewControllers.removeAll(where: {$0 == self})
                    viewControllers.append(vc)
                    self.navigationController?.setViewControllers(viewControllers, animated: true)
                }
            } else if error?.messageKey == ErrorKeys.reject.rawValue, let message = error?.localizedMessage {
                let dialog = Dialog.loadFromNib()
                dialog.setup(type: .error, title: "Oh no!", message: message, neutralButtonTitle: "OK") { _ in
                    self.navigationController?.popViewController(animated: true)
                }
                dialog.makeKeyAndVisible()
            }
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
}
