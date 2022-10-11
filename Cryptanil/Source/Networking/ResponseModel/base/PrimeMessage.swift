//
//  PrimeMessage.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 03.10.22.
//

import Foundation

struct PrimeMessage: Codable {
    var localizedMessage: String?
    var messageKey: String?
}

enum MessageKeys: String {
    case success
    case serviceNotAvailable
    case promoCodeNotFound
}

enum ErrorKeys: String {
    case reject
}

enum PrimeMessageKey:String {
    case sessionExpired = "sessionExpired"
}
