//
//  PrimeResult.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 03.10.22.
//

import Foundation

struct PrimeResult<T:Codable>: Codable {
    var data: T?
    var message: PrimeMessage?
}
