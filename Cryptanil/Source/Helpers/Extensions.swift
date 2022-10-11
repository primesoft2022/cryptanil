//
//  Extensions.swift
//  Pods
//
//  Created by Hayk Movsesyan on 03.10.22.
//

import UIKit

extension UIView {
    
    static func loadFromNib() -> Self {
        func instanceFromNib<T: UIView>() -> T {
            let bundle = Bundle(for: T.self)
            let name = T.self.description().components(separatedBy: ".").last ?? ""
            guard let view = bundle.loadNibNamed(name, owner: nil, options: nil)?.compactMap({ $0 as? T }).last else {
                return T()
            }
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return view
        }
        
        return instanceFromNib()
    }
    
    class func loadFromNib<T>(withName nibName: String) -> T? {
        let nib = UINib.init(nibName: nibName, bundle: nil)
        let nibObjects = nib.instantiate(withOwner: nil, options: nil)
        for object in nibObjects {
            if let result = object as? T {
                return result
            }
        }
        return nil
    }
    
    func makeKeyAndVisible(completion: (() -> Void)? = nil) {
        if let window = UIApplication.shared.windows.first {
            if !window.subviews.contains(where: {$0 is Dialog}) {
                self.frame = window.bounds
                self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                window.addSubview(self)
            }
        }
        completion?()
    }
    
    func hideWithOpacity() {
        if !isHidden {
            isHidden = true
        }
        alpha = 0
    }
    
    func showWithOpacity() {
        isHidden = false
        alpha = 1
    }
    
    func disable() {
        isUserInteractionEnabled = false
        alpha = 0.5
    }
    
    func enable() {
        isUserInteractionEnabled = true
        alpha = 1
    }
}

extension Encodable {
    
    func jsonData()->Data{
        return try! JSONEncoder().encode(self)
    }
}
