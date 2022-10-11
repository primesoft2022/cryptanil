//
//  CreateOrderRequest.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 03.10.22.
//

import Foundation
import Alamofire

struct GetCoinAddressRequest: Codable {
    
    let auth: String
    let coin: String
    let network: String
    
    var parameters: Parameters {
        return ["auth": auth, "coin": coin, "network": network]
    }
}
