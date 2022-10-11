//
//  File.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 03.10.22.
//

import UIKit

class Dialog: UIView {
    
    @IBOutlet weak var showingView: UIView!
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertMessage: UILabel!
    @IBOutlet weak var alertTitle: UILabel!
    @IBOutlet weak var alertImageView: UIImageView!
    @IBOutlet weak var alertButton: UIButton!
    
    @IBOutlet weak var vev: UIVisualEffectView!
    var ve: UIVisualEffect!

    var isCancelable: Bool = true
    var actionAfterRemoving = false
    var action: ((Dialog.ActionType) -> Void)?
    var dialogType: DialogType!
    
    func setup(type: DialogType!, title: String = "Congratulations", message: String? = nil, neutralButtonTitle: String = "OK", isCancelable: Bool = true, actionAfterRemoving: Bool = false, completion: ((Dialog.ActionType) ->Void )? = nil) {
        self.isCancelable = isCancelable
        self.action = completion
        self.actionAfterRemoving = actionAfterRemoving
        self.dialogType = type
        setupView(for: type, title: title, message: message ?? "", neutralButtonTitle: neutralButtonTitle)
    }
    
    func setupView(for type: DialogType, title: String, message: String, neutralButtonTitle:String) {
        switch type {
        case .error:
            setupErrorDialog(title: title, message: message, neutralButtonTitle: neutralButtonTitle)
        case .internetConnection:
            setupInternetConnectionDialog(title: title, message: message, neutralButtonTitle: neutralButtonTitle)
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
    
    
    @IBAction func cancel(_ sender: UIButton) {
        if(isCancelable){
            action?(.neutral)
            dismissDialog {
            }
        }
    }
    
    
    @IBAction func actionTapped(_ sender: UIButton) {
        dismissDialog {
            if let action = self.action {
                switch sender.tag {
                case 1:
                    action(.neutral)
                case 2:
                    action(.negative)
                case 3:
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
            self.vev.effect = nil
        }) { (_) in
            self.removeFromSuperview()
            if self.actionAfterRemoving {
                completion()
            }
        }
    }
}

extension Dialog {
    
    enum DialogType {
        case error
        case internetConnection
    }

    enum ActionType {
        case negative
        case positive
        case neutral
    }
}
