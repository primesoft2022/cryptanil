//
//  Loading.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 03.10.22.
//

import UIKit

class CryptanilLoading: UIView {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var isFLipping = false
    var canRemoveSelf = false
    
    func startLoading() {
        activityIndicator.startAnimating()
        isFLipping = true
    }
    
    func stopLoading(animated: Bool = true) {
        activityIndicator.stopAnimating()
        self.removeFromSuperview()
        isFLipping = false
    }
    
    func isCurrentlyFlipping() -> Bool {
        return isFLipping
    }
}

