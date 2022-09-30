//
//  Colors.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 28.09.22.
//

import Foundation

class Colors {
    
    static func background() -> UIColor {
        return UIColor(named: "background", in: Bundle(for: self), compatibleWith: nil) ?? UIColor()
    }
    
    static func gray() -> UIColor {
        return UIColor(named: "gray", in: Bundle(for: self), compatibleWith: nil) ?? UIColor()
    }
    
    static func blue() -> UIColor {
        return UIColor(named: "blue", in: Bundle(for: self), compatibleWith: nil) ?? UIColor()
    }
    
    static func black() -> UIColor {
        return UIColor(named: "black", in: Bundle(for: self), compatibleWith: nil) ?? UIColor()
    }
}
