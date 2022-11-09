//
//  Images.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 30.09.22.
//

import Foundation

class CryptanilImages {
    
    static var logo: UIImage {
        UIImage(named: "logo", in: Bundle(for: self), compatibleWith: nil) ?? UIImage()
    }
    
    static var submitted: UIImage {
        UIImage(named: "submitted", in: Bundle(for: self), with: nil) ?? UIImage()
    }
    
    static var complited: UIImage {
        UIImage(named: "complited", in: Bundle(for: self), with: nil) ?? UIImage()
    }
    
    static var error: UIImage {
        UIImage(named: "error", in: Bundle(for: self), with: nil) ?? UIImage()
    }
    
    static var expired: UIImage {
        UIImage(named: "expired", in: Bundle(for: self), with: nil) ?? UIImage()
    }
    
    static var warning: UIImage {
        UIImage(named: "warning", in: Bundle(for: self), with: nil) ?? UIImage()
    }
}
