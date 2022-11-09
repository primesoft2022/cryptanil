//
//  File.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 03.10.22.
//

import UIKit

class CryptanilDialog: UIView {
    
    @IBOutlet weak var showingView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertMessage: UILabel!
    @IBOutlet weak var alertTitle: UILabel!
    @IBOutlet weak var alertImageView: UIImageView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var vev: UIVisualEffectView!
    
    var ve: UIVisualEffect!
    var actionAfterRemoving = false
    var action: ((CryptanilDialog.ActionType) -> Void)?
    var dialogType: DialogType!
    
    func setup(type: DialogType!, completion: ((CryptanilDialog.ActionType) ->Void )? = nil) {
        self.action = completion
        self.dialogType = type
        setupView(for: type)
    }
    
    func setupView(for type: DialogType) {
        switch type {
        case .error(let error):
            setupErrorDialog(error: error)
        case .internetConnection:
            setupInternetConnectionDialog()
            actionAfterRemoving = true
        case .underConstruction:
            setupMaintenanceDialog()
        case .undefined:
            setupUndefinedDialog()
        }
        showingView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        showingView.alpha = 0
        ve = vev.effect
        vev.effect = nil
        makeKeyAndVisible() {
            UIView.animate(withDuration: 0.35) {
                self.showingView.alpha = 1
                self.showingView.transform = CGAffineTransform.identity
                self.vev.effect = self.ve
            }
        }
    }
    
    @IBAction func actionTapped(_ sender: UIButton) {
        dismissDialog {
            if let action = self.action {
                switch sender.tag {
                case 1:
                    action(.cancel)
                case 2:
                    action(.positive)
                default:
                    break
                }
            }
        }
    }
    
    func dismissDialog(_ completion: @escaping () -> Void) {
        if !actionAfterRemoving {
            completion()
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.showingView.alpha = 0
            self.showingView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            self.vev.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
            if self.actionAfterRemoving {
                completion()
            }
        }
    }
}

extension CryptanilDialog {
    
    private func setupErrorDialog(error: CryptanilError) {
        alertImageView.image = CryptanilImages.error
        actionButton.setTitle("Ok", for: .normal)
        cancelButton.removeFromSuperview()
        alertTitle.text = "Oh no!"
        alertMessage.text = error.localizedMessage
    }
    
    private func setupInternetConnectionDialog() {
        alertImageView.image = CryptanilImages.error
        actionButton.setTitle("Try again", for: .normal)
        alertTitle.text = "No Internet Connection"
        alertMessage.text = "Connect to internet and try again"
    }
    
    private func setupUndefinedDialog() {
        alertImageView.image = CryptanilImages.error
        actionButton.setTitle("Ok", for: .normal)
        cancelButton.removeFromSuperview()
        alertTitle.text = "Oh no!"
        alertMessage.text = "Sorry about the technical problems at the moment. We are working to fix the problems as soon as possible. Try a little later."
    }
    
    private func setupMaintenanceDialog() {
        alertImageView.image = CryptanilImages.error
        actionButton.removeFromSuperview()
        alertTitle.text = "Under construction"
        alertMessage.text = "Sorry, the website is under construction.\nPlease wait few seconds."
    }
}


extension CryptanilDialog {
    
    enum DialogType {
        case error(CryptanilError)
        case underConstruction
        case internetConnection
        case undefined
    }

    enum ActionType {
        case cancel
        case positive
    }
}
