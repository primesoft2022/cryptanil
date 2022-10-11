//
//  GetCryptanilOrderInfo.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 03.10.22.
//

import Foundation
import Alamofire

struct GetCryptanilOrderInfoRequest: Codable {
    
    let auth: String
    
    var parameters: String {
        return "?auth=\(auth)"
    }
}
