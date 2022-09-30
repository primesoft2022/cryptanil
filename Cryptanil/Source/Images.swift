//
//  Images.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 30.09.22.
//

import Foundation

class Images {
    
    static var logo: UIImage {
        UIImage(named: "logo", in: Bundle(for: self), compatibleWith: nil) ?? UIImage()
    }
}
