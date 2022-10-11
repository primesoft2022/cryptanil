//
//  ApiClient+UI.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 03.10.22.
//

import Alamofire
import UIKit

extension ApiClient {
    
    private (set) static var counter: Int = 0
    
    static func increment() {
        loadingQueue.sync {
            counter += 1
        }
    }
    
    static func decrement(){
        loadingQueue.sync {
            counter > 0 ? (counter -= 1) : (counter = 0)
        }
    }
    
    static func startLoading(){
        if (loading == nil) {
            loading = Loading.loadFromNib()
        }
        if (!loading.isCurrentlyFlipping()) {
            loading?.startLoading()
            attachDialogToWindow(dialog: loading!)
        }
    }
    
    static func stopLoading(with message: String? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if counter == 0 {
                loading?.stopLoading(with: message)
            }
        }
    }
    
    public static func attachDialogToWindow(dialog: UIView) {
        if let window = UIApplication.shared.windows.first {
            if !window.subviews.contains(where: {$0 is Dialog}) {
                dialog.frame = window.bounds
                dialog.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                window.addSubview(dialog)
            }
        }
    }
    
    public static func handleSwiftError(_ error: Swift.Error!){
        let dialog: Dialog = Dialog.loadFromNib()
        dialog.setup(type: .error,message: "Sorry about the technical problems at the moment. We are working to fix the problems as soon as possible. Try a little later.")
    }
    
    public static func handlePrimeError(_ error: PrimeError!){
        let dialog: Dialog = Dialog.loadFromNib()
        if let errorMessage = error.localizedMessage {
            dialog.setup(type: .error, message: errorMessage)
        }
    }
    
    public static func handleNoInternetConnection(isCancelable: Bool = true){
        let dialog: Dialog = Dialog.loadFromNib()
        dialog.setup(type: .internetConnection, title: "No Internet Connection", message: "Connect to internet and try again", isCancelable: isCancelable)
    }
}
