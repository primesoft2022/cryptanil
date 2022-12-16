//
//  AppLanguage.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 17.10.22.
//

import Foundation

public enum CryptanilLanguage: String, CaseIterable {
    
    case en = "en"
    case ru = "ru"
    case es = "es"
    case de = "de"
    case fr = "fr"
    
    static var current: CryptanilLanguage = .en
}
