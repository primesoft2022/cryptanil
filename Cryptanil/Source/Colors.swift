//
//  Colors.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 28.09.22.
//

import Foundation

class Colors {
    
    static var background: UIColor {
        UIColor(named: "background", in: Bundle(for: self), compatibleWith: nil) ?? UIColor()
    }
    static var gray: UIColor {
        UIColor(named: "gray", in: Bundle(for: self), compatibleWith: nil) ?? UIColor()
    }
    static var blue: UIColor {
        UIColor(named: "blue", in: Bundle(for: self), compatibleWith: nil) ?? UIColor()
    }
    static var black: UIColor {
        UIColor(named: "black", in: Bundle(for: self), compatibleWith: nil) ?? UIColor()
    }
    static var inputBackground: UIColor {
        UIColor(named: "inputBackground", in: Bundle(for: self), compatibleWith: nil) ?? UIColor()
    }
}
