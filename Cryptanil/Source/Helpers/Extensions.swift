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
    
    func jsonData()->Data{
        return try! JSONEncoder().encode(self)
    }
}

extension String {
    
    func localized() -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.localizedBundle(), value: "", comment: "")
    }
    
    func toQrCode() -> UIImage? {
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(self.data(using: String.Encoding.ascii), forKey: "inputMessage")
        let filterFalseColor = CIFilter(name: "CIFalseColor")
        filterFalseColor?.setDefaults()
        filterFalseColor?.setValue(filter?.outputImage, forKey: "inputImage")
        // convert method
        let cgColor: CGColor? = Colors.blue.cgColor
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
    
    private static var bundle: Bundle!
    
    public static func localizedBundle() -> Bundle! {
        if bundle == nil {
            let appLang = Language.de// AppLanguage(rawValue: UserDefaults.standard.string(forKey: "app_lang") ?? "") ?? 
            let path = Bundle(identifier: "org.cocoapods.Cryptanil")?.path(forResource: appLang.rawValue, ofType: "lproj")
            bundle = Bundle(path: path!)
        }
        return bundle
    }
    
    public static func setLanguage(lang: Language) {
        UserDefaults.standard.set(lang.rawValue, forKey: "app_lang")
        let path = Bundle.main.path(forResource: lang.rawValue, ofType: "lproj")
        bundle = Bundle(path: path!)
    }
    
    public static func getLanguage() -> Language {
        let langVal = UserDefaults.standard.string(forKey: "app_lang")
        let lang = Language(rawValue: langVal ?? "") ?? .en
        return lang
    }
    
}
