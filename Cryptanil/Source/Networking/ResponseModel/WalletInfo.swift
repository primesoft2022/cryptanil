//
//  GetWalletInfoResponse.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 03.10.22.
//

import Foundation

struct WalletInfo: Codable {
    
    let coin: String
    let depositAllEnable: Bool
    let locked: String
    let freeze: Int
    let networkList: [Network]
}

struct Network: Codable {
    
    let network, name, coin: String
    let isDefault, depositEnable: Bool
}
