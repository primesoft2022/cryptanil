//
//  PrimeError.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 03.10.22.
//

import Foundation

@objc public class CryptanilError: NSObject, Codable {
    
    public var localizedMessage: String?
    public var messageKey: String?
    
    init(localizedMessage: String, messageKey: String) {
        self.localizedMessage = localizedMessage
        self.messageKey = messageKey
    }
    
    static var undefined: CryptanilError {
        return CryptanilError(localizedMessage: "undefined problem with network", messageKey: CryptanilErrorKeys.undefined.rawValue)
    }
    
    static var maintenance: CryptanilError {
        return CryptanilError(localizedMessage: "the website is under construction", messageKey: CryptanilErrorKeys.maintenance.rawValue)
    }
    
    static var noInternetConnection: CryptanilError {
        return CryptanilError(localizedMessage: "No Internet Connection", messageKey: CryptanilErrorKeys.internetConnectionFailed.rawValue)
    }
}

public enum CryptanilErrorKeys: String {
    
    case reject
    case internetConnectionFailed
    case maintenance
    case undefined
}
