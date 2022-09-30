//
//  ViewController.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 09/29/2022.
//  Copyright (c) 2022 Hayk Movsesyan. All rights reserved.
//

import UIKit
import Cryptanil

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let vc = CryptanilViewController()
        present(vc, animated: true)
    }
}

