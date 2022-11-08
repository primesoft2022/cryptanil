//
//  PrimeMessage.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 03.10.22.
//

import Foundation

struct CryptanilMessage: Codable {
    var localizedMessage: String?
    var messageKey: String?
}

enum CryptanilMessageKeys: String {
    case success
}
