//
//  PaymentStatusViewController.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 05.10.22.
//

import UIKit

class PaymentStatusViewController: UIViewController {
    
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var headerView: UIView!
    private var infoStackView: UIStackView!
    
    var orderInfo: CryptanilOrderInfo!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    init(orderInfo: CryptanilOrderInfo) {
        self.orderInfo = orderInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        view.backgroundColor = Colors.background
        setupScrollView()
        setupContentView()
        setupHeader()
        setupInfoStackView()
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
        headerView = UIView()
        contentView.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = OrderStatuses(rawValue: orderInfo.status)?.image
        headerView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 135).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 111).isActive = true
        imageView.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.text = OrderStatuses(rawValue: orderInfo.status)?.title
        titleLabel.textColor = Colors.black
        titleLabel.textAlignment = .center
        headerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        let messageLabel = UILabel()
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.text = OrderStatuses(rawValue: orderInfo.status)?.message
        if orderInfo.status == OrderStatuses.expired.rawValue {
            messageLabel.textColor = Colors.red
        } else {
            messageLabel.textColor = Colors.blue
        }
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        headerView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
    }
    
    private func setupInfoStackView() {
        infoStackView = UIStackView()
        infoStackView.alignment = .fill
        infoStackView.distribution = .equalSpacing
        infoStackView.axis = .vertical
        infoStackView.spacing = 14
        let coinAmount = setupInfoView(title: "Coin amount", info: orderInfo.cryptoAmount ?? "-", previousInfoView: nil, for: infoStackView)
        if let convertedAmount = orderInfo.convertedAmountToString {
            let _ = setupInfoView(title: "Converted amount", info: "\(convertedAmount)", previousInfoView: coinAmount, for: infoStackView)
        }
        let _ = setupInfoView(title: "TxID", info: orderInfo.txID ?? "", previousInfoView: coinAmount, for: infoStackView)
        let _ = setupInfoView(title: "Company name", info: orderInfo.companyName, previousInfoView: coinAmount, for: infoStackView)
        contentView.addSubview(infoStackView)
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        infoStackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 30).isActive = true
        infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        infoStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    private func setupInfoView(title: String, info: String, previousInfoView: UIView?, for stackView: UIStackView) -> UIView {
        let infoView = UIView()
        stackView.addArrangedSubview(infoView)
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.text = title
        titleLabel.textColor = Colors.black
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        infoView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: infoView.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: infoView.bottomAnchor).isActive = true
        let infoLabel = UILabel()
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        infoLabel.text = info
        infoLabel.textColor = Colors.black
        infoLabel.numberOfLines = 0
        infoView.addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 20).isActive = true
        if let previousInfoView = previousInfoView {
            infoLabel.leadingAnchor.constraint(equalTo: previousInfoView.leadingAnchor).isActive = true
        }
        infoLabel.topAnchor.constraint(equalTo: infoView.topAnchor).isActive = true
        infoLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor).isActive = true
        infoLabel.bottomAnchor.constraint(equalTo: infoView.bottomAnchor).isActive = true
        return infoLabel
    }
}
