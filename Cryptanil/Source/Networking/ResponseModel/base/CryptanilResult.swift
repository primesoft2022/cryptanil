//
//  PrimeResult.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 03.10.22.
//

import Foundation

struct CryptanilResult<T:Codable>: Codable {
    var data: T?
    var message: CryptanilMessage?
}
