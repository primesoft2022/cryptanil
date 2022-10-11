//
//  Dialog+Success+Error.swift
//  Cryptanil-Resources
//
//  Created by Hayk Movsesyan on 03.10.22.
//

import UIKit

extension Dialog {
    
    func setupErrorDialog(title: String, message: String, neutralButtonTitle: String){
        alertImageView.image = Images.warning
        alertButton.setTitle(neutralButtonTitle, for: .normal)
        alertTitle.text = title
        alertMessage.text = message
    }
    
    func setupInternetConnectionDialog(title: String, message: String, neutralButtonTitle: String) {
        alertImageView.image = Images.warning
        if !isCancelable {
            alertButton.removeFromSuperview()
        }
        alertTitle.text = title
        alertMessage.text = message
    }
}
