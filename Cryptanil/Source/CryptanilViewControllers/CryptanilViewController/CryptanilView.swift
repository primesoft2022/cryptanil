//
//  CryptanilView.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 16.12.22.
//

import UIKit

class CryptanilView: UIView {
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        let iconView = UIImageView()
        iconView.image = CryptanilImages.logo
        addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        iconView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        let cryptalinLabel = UILabel()
        cryptalinLabel.text = "Cryptanil"
        cryptalinLabel.font = UIFont.systemFont(ofSize: 24)
        cryptalinLabel.textColor = CryptanilColors.black
        cryptalinLabel.textAlignment = .center
        addSubview(cryptalinLabel)
        cryptalinLabel.translatesAutoresizingMaskIntoConstraints = false
        cryptalinLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 20).isActive = true
        cryptalinLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        cryptalinLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        cryptalinLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

