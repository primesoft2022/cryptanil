//
//  GetCryptanilOrderInfoResponse.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 03.10.22.
//

import Foundation

struct CryptanilOrderInfo: Codable {
    
    let status: Int
    let orderID, convertedCoinType: String
    let redirectURL: String
    let isTesting: Bool
    let companyName: String
    let depositCoinType: String?
    let convertDate: String?
    let convertedAmount: Double?
    let convertedAmountCurrency: Double?
    let currencyCode: String?
    let cryptoAmount: String?
    let txId: String?

    enum CodingKeys: String, CodingKey {
        case status, depositCoinType, convertDate, convertedAmount, convertedAmountCurrency, currencyCode, cryptoAmount, txId
        case orderID = "orderId"
        case convertedCoinType
        case redirectURL = "redirectUrl"
        case isTesting, companyName
    }
}

enum OrderStatuses: Int {
    
  case created = 1
  case submitted = 2
  case expired = 3
  case completed = 4
}
