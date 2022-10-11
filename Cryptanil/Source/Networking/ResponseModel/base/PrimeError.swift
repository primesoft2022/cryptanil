//
//  PrimeError.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 03.10.22.
//

import Foundation

struct PrimeError: Codable {
    var localizedMessage: String?
    var messageKey: String?
    
    static func noInternetError() -> PrimeError {
        var error: PrimeError = PrimeError()
        error.localizedMessage = "No Internet Connection."
        error.messageKey = "no_internet"
        return error
    }
}

