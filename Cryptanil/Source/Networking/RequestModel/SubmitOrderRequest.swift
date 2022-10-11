//
//  SubmitOrderRequest.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 04.10.22.
//

import Foundation

struct SubmitOrderRequest: Codable {
    let txId: String
    let auth: String
}
