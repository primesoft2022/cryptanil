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
            if !window.subviews.contains(where: {$0 is CryptanilDialog}) {
                self.frame = window.bounds
                self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                window.addSubview(self)
            }
        }
        completion?()
    }
    
    @objc func hideWithOpacity() {
        if !isHidden {
            isHidden = true
        }
        alpha = 0
    }
    
    func showWithOpacity() {
        isHidden = false
        alpha = 1
    }
    
    @objc func disable() {
        isUserInteractionEnabled = false
        alpha = 0.6
    }
    
    @objc func enable() {
        isUserInteractionEnabled = true
        alpha = 1
    }
}

extension Encodable {
    
    func cryptanilJsonData()->Data{
        return try! JSONEncoder().encode(self)
    }
}

extension String {
    
    func cryptanilLocalized() -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.localizedCryptanilBundle(), value: "", comment: "")
    }
    
    func toCryptanilQrCode() -> UIImage? {
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(self.data(using: String.Encoding.ascii), forKey: "inputMessage")
        let filterFalseColor = CIFilter(name: "CIFalseColor")
        filterFalseColor?.setDefaults()
        filterFalseColor?.setValue(filter?.outputImage, forKey: "inputImage")
        // convert method
        let cgColor: CGColor? = CryptanilColors.blue.cgColor
        let qrColor: CIColor = CIColor(cgColor: cgColor!)
        let transparentBG: CIColor = CIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        filterFalseColor?.setValue(qrColor, forKey: "inputColor0")
        filterFalseColor?.setValue(transparentBG, forKey: "inputColor1")
        if let image = filterFalseColor?.outputImage {
            let transform = CGAffineTransform(scaleX: 5.0, y: 5.0)
            return UIImage(ciImage: image.transformed(by: transform),
                           scale: 1.0,
                           orientation: UIImageOrientation.up)
        } else {
            return nil
        }
    }
}

extension UIViewController {
    
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return (navigation.visibleViewController?.topMostViewController())!
        }
        return (self.presentedViewController?.topMostViewController())!
    }
}

extension Bundle {
    
    private static var cryptanilBundle: Bundle!
    
    public static func localizedCryptanilBundle() -> Bundle {
        if cryptanilBundle == nil {
            let appLang = CryptanilLanguage.current
            let path = Bundle(identifier: "org.cocoapods.Cryptanil")?.path(forResource: appLang.rawValue, ofType: "lproj")
            cryptanilBundle = Bundle(path: path!)
        }
        return cryptanilBundle
    }
}
