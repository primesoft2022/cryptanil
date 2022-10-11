//
//  Loading.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 03.10.22.
//

import UIKit

class Loading: UIView {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var successImage: UIImageView!
    @IBOutlet weak var successImageHeight: NSLayoutConstraint!
    @IBOutlet weak var successImageWidth: NSLayoutConstraint!
    
    var isFLipping = false
    var canRemoveSelf = false
    
    func startLoading() {
        activityIndicator.startAnimating()
        isFLipping = true
        canRemoveSelf = false
    }
    
    func stopLoading(with message: String? = nil, animated: Bool = true) {
        activityIndicator.stopAnimating()
        if let message = message {
            UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
                self.activityIndicator.isHidden = true
                self.successImageWidth.constant = 37
                self.successImageHeight.constant = 37
                self.titleLabel.text = message
            }) { (_) in
                self.layoutIfNeeded()
                self.canRemoveSelf = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.removeFromSuperview()
                }
            }
        } else {
            self.removeFromSuperview()
        }
        isFLipping = false
    }
    
    func showSuccess(message: String) {
        self.activityIndicator.isHidden = true
        self.successImageWidth.constant = 37
        self.successImageHeight.constant = 37
        self.titleLabel.text = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.removeFromSuperview()
        }
    }
    
    func isCurrentlyFlipping() -> Bool {
        return isFLipping
    }
    
    @IBAction func removeSelf() {
        if canRemoveSelf {
            self.removeFromSuperview()
        }
    }
}

