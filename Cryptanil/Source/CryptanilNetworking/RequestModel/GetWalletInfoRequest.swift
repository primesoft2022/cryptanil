//
//  GetWalletInfo.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 03.10.22.
//

import Foundation
import Alamofire

struct GetWalletInfoRequest: Codable {
    
    let auth: String
    
    var parameters: String {
        return "?auth=\(auth)"
    }
}
