//
//  Colors.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 28.09.22.
//

import Foundation

class CryptanilColors {
    
    static var background: UIColor {
        UIColor(named: "background", in: Bundle(for: self), compatibleWith: nil) ?? UIColor.systemBackground
    }
    static var gray: UIColor {
        UIColor(named: "gray", in: Bundle(for: self), compatibleWith: nil) ?? UIColor.gray
    }
    static var blue: UIColor {
        UIColor(named: "blue", in: Bundle(for: self), compatibleWith: nil) ?? UIColor.blue
    }
    static var black: UIColor {
        UIColor(named: "black", in: Bundle(for: self), compatibleWith: nil) ?? UIColor.darkText
    }
    static var inputBackground: UIColor {
        UIColor(named: "inputBackground", in: Bundle(for: self), compatibleWith: nil) ?? UIColor.lightGray
    }
    
    static var red: UIColor {
        UIColor(named: "red", in: Bundle(for: self), compatibleWith: nil) ?? UIColor.red
    }
    
    static var loading_background: UIColor {
        UIColor(named: "loading_background", in: Bundle(for: self), compatibleWith: nil) ?? UIColor.gray
    }
}
