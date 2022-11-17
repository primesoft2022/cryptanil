//
//  ViewController.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 09/29/2022.
//  Copyright (c) 2022 Hayk Movsesyan. All rights reserved.
//

import UIKit
import Cryptanil
import Alamofire

class ViewController: UIViewController, CryptanilViewControllerDelegate {
    @IBOutlet weak var idTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func show() {
        let vc = CryptanilViewController(orderId: idTF.text!, delegate: self)
        vc.language = .es
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func cryptanilTransactionChanged(to status: Cryptanil.CryptanilOrderStatus, for orderInfo: Cryptanil.CryptanilOrderInfo) {
        
    }
}

