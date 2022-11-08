//
//  TopMessage.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 15.10.22.
//

import Foundation

class CryptanilTopMessage {
    
    static func show(message: String) {
        if let viewController = UIApplication.shared.keyWindow?.rootViewController?.topMostViewController(), let view = viewController.view {
            let messageView = UIView()
            messageView.layer.cornerRadius = 8
            messageView.backgroundColor = CryptanilColors.loading_background
            view.addSubview(messageView)
            messageView.translatesAutoresizingMaskIntoConstraints = false
            messageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20 + view.safeAreaInsets.top).isActive = true
            messageView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20).isActive = true
            messageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            let messageLabel = UILabel()
            messageLabel.text = message
            messageLabel.font = UIFont.systemFont(ofSize: 16)
            messageLabel.textColor = .white
            messageView.addSubview(messageLabel)
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            messageLabel.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 10).isActive = true
            messageLabel.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 20).isActive = true
            messageLabel.centerXAnchor.constraint(equalTo: messageView.centerXAnchor).isActive = true
            messageLabel.centerYAnchor.constraint(equalTo: messageView.centerYAnchor).isActive = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                messageView.removeFromSuperview()
            }
        }
    }
}
