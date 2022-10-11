//
//  GetCoinAddressResponse.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 03.10.22.
//

import Foundation

struct CoinAddress: Codable {
    
    let coin, address, tag: String
    let url: String
    let memo: String?
}
