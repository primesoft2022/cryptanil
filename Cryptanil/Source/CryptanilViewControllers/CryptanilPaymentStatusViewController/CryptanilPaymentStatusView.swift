//
//  CryptanilPaymentStatusView.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 16.12.22.
//

import Foundation

protocol CryptanilPaymentStatusViewDelegate: AnyObject {
    func doneTapped()
}
 
final class CryptanilPaymentStatusView: UIView {
    
    private var headerView: UIView!
    private var infoStackView: UIStackView!
    private var imageView: UIImageView!
    private var titleLabel: UILabel!
    private var messageLabel: UILabel!
    private var progressView: UIView?
    private var doneButton: UIButton!
    
    var orderInfo: CryptanilOrderInfo!
        
    weak var delegate: CryptanilPaymentStatusViewDelegate!
    
    init(orderInfo: CryptanilOrderInfo) {
        super.init(frame: .zero)
        self.orderInfo = orderInfo
        setupHeader()
        setupInfoStackView()
        setupSubmitButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHeader() {
        headerView = UIView()
        addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        headerView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 135).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 111).isActive = true
        imageView.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = CryptanilColors.black
        titleLabel.textAlignment = .center
        headerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        messageLabel = UILabel()
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        if orderInfo.status == CryptanilOrderStatus.expired.rawValue {
            messageLabel.textColor = CryptanilColors.red
        } else {
            messageLabel.textColor = CryptanilColors.blue
        }
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        headerView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        if CryptanilOrderStatus(rawValue: orderInfo.status) == .submitted {
            progressView = CryptanilProgress()
            headerView.addSubview(progressView!)
            progressView!.translatesAutoresizingMaskIntoConstraints = false
            progressView!.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20).isActive = true
            progressView!.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20).isActive = true
            progressView!.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20).isActive = true
            progressView!.heightAnchor.constraint(equalToConstant: 10).isActive = true
            progressView!.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
            progressView?.layoutIfNeeded()
        } else {
            messageLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        }
    }
    
    private func setupInfoStackView() {
        infoStackView = UIStackView()
        infoStackView.alignment = .fill
        infoStackView.distribution = .fillProportionally
        infoStackView.axis = .vertical
        infoStackView.spacing = 14
        addSubview(infoStackView)
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        infoStackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 30).isActive = true
        infoStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    private func setupSubmitButton() {
        doneButton = UIButton()
        doneButton.backgroundColor = CryptanilColors.blue
        doneButton.setTitle("Go to merchant page".cryptanilLocalized(), for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.layer.cornerRadius = 10
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        doneButton.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 20).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    @objc private func doneTapped() {
        delegate?.doneTapped()
    }
    
    func setupInfo() {
        imageView.image = CryptanilOrderStatus(rawValue: orderInfo.status)?.image
        titleLabel.text = CryptanilOrderStatus(rawValue: orderInfo.status)?.title
        messageLabel.text = CryptanilOrderStatus(rawValue: orderInfo.status)?.message
        for view in infoStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        let coinAmount = setupInfoView(title: "Coin amount".cryptanilLocalized(), info: orderInfo.cryptoAmount ?? "-", previousInfoView: nil, for: infoStackView)
        if let convertedAmount = orderInfo.convertedAmountToString {
            let _ = setupInfoView(title: "Converted amount".cryptanilLocalized(), info: "\(convertedAmount)", previousInfoView: coinAmount, for: infoStackView)
        }
        if let convertedCurrency = orderInfo.convertedCurrencyToString {
            let _ = setupInfoView(title: "Converted Currency".cryptanilLocalized(), info: "\(convertedCurrency)", previousInfoView: coinAmount, for: infoStackView)
        }
        if let merchantCommision = orderInfo.merchantCommissionString {
            let _ = setupInfoView(title: "Merchant %".cryptanilLocalized(), info: "\(merchantCommision)", previousInfoView: coinAmount, for: infoStackView)
        }
        if let merchantCommisionCurrency = orderInfo.merchantCommissionCurrencyString {
            let _ = setupInfoView(title: "Merchant % Currency".cryptanilLocalized(), info: "\(merchantCommisionCurrency)", previousInfoView: coinAmount, for: infoStackView)
        }
        if let amountToShow = orderInfo.amountToShowString {
            let _ = setupInfoView(title: "Amount".cryptanilLocalized(), info: "\(amountToShow)", previousInfoView: coinAmount, for: infoStackView)
        }
        if let amountToShowCurrency = orderInfo.amountToShowCurrencyString {
            let _ = setupInfoView(title: "Amount Currency".cryptanilLocalized(), info: "\(amountToShowCurrency)", previousInfoView: coinAmount, for: infoStackView)
        }
        let _ = setupInfoView(title: "TxID".cryptanilLocalized(), info: orderInfo.txID ?? "", previousInfoView: coinAmount, for: infoStackView)
        let _ = setupInfoView(title: "Company name".cryptanilLocalized(), info: orderInfo.companyName, previousInfoView: coinAmount, for: infoStackView)
        if CryptanilOrderStatus(rawValue: orderInfo.status) != .submitted {
            progressView?.removeFromSuperview()
            messageLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        }
    }
    
    private func setupInfoView(title: String, info: String, previousInfoView: UIView?, for stackView: UIStackView) -> UIView {
        let infoView = UIView()
        stackView.addArrangedSubview(infoView)
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.text = title
        titleLabel.textColor = CryptanilColors.black
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
        infoLabel.textColor = CryptanilColors.black
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
        infoLabel.setContentHuggingPriority(.required, for: .vertical)
        infoLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        return infoLabel
    }
}
