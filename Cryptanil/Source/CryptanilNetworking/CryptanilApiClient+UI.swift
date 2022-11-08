//
//  ApiClient+UI.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 03.10.22.
//

import Alamofire
import UIKit

extension CryptanilApiClient {
    
    private (set) static var counter: Int = 0
    
    static func increment() {
        loadingQueue.sync {
            counter += 1
        }
    }
    
    static func decrement() {
        loadingQueue.sync {
            counter > 0 ? (counter -= 1) : (counter = 0)
        }
    }
    
    static func startLoading() {
        if loading == nil {
            loading = CryptanilLoading.loadFromNib()
        }
        if !loading!.isCurrentlyFlipping() {
            loading!.startLoading()
            attachDialogToWindow(dialog: loading!)
        }
    }
    
    static func stopLoading(with message: String? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if counter == 0 {
                loading?.stopLoading()
            }
        }
    }
    
    static func attachDialogToWindow(dialog: UIView) {
        if let window = UIApplication.shared.windows.first {
            if !window.subviews.contains(where: {$0 is CryptanilDialog}) {
                dialog.frame = window.bounds
                dialog.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                window.addSubview(dialog)
            }
        }
    }
    
    static func handleUndefinedError(action: @escaping () -> Void) {
        let dialog: CryptanilDialog = CryptanilDialog.loadFromNib()
        dialog.setup(type: .undefined)
    }
    
    static func handleMaintenanceError(stopTransaction: @escaping () -> Void) {
        let dialog: CryptanilDialog = CryptanilDialog.loadFromNib()
        dialog.setup(type: .underConstruction) { action in
            if action == .cancel {
                stopTransaction()
            }
        }
    }
    
    static func handlePrimeError(_ error: CryptanilError!, stopTransaction: @escaping () -> Void) {
        let dialog: CryptanilDialog = CryptanilDialog.loadFromNib()
        dialog.setup(type: .error(error)) { action in
            stopTransaction()
        }
    }
    
    static func handleNoInternetConnection(completion: @escaping (CryptanilDialog.ActionType) -> Void){
        let dialog: CryptanilDialog = CryptanilDialog.loadFromNib()
        dialog.setup(type: .internetConnection) { action in
            completion(action)
        }
    }
}
