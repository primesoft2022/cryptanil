//
//  SubmitOrderResponse.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 04.10.22.
//

import Foundation

// MARK: - SubmitOrderResponse
struct CryptanilOrderInfo: Codable {
    let status: Int
    let orderID, convertedCoinType, redirectURL: String
    let isTesting: Bool
    let companyName: String
    let txID: String?
    let callBackFail: Bool
    let convertedAmountCurrency: Double?
    let convertedAmount: Double?
    let cryptoAmount: String?
    let currencyCode: String?
    
    var convertedAmountToString: String? {
        if let convertedAmount = convertedAmount, let convertedAmountCurrency = convertedAmountCurrency, let currencyCode = currencyCode {
            return "\(convertedAmount) (\(convertedCoinType))\n\(convertedAmountCurrency) (\(currencyCode))"
        } else if let convertedAmount = convertedAmount {
            return "\(convertedAmount) (\(convertedCoinType))"
        }else if let convertedAmountCurrency = convertedAmountCurrency, let currencyCode = currencyCode {
            return "\(convertedAmountCurrency) (\(currencyCode))"
        }
        return nil
    }

    enum CodingKeys: String, CodingKey {
        case status
        case orderID = "orderId"
        case convertedCoinType
        case redirectURL = "redirectUrl"
        case isTesting, companyName
        case txID = "txId"
        case callBackFail, convertedAmountCurrency, convertedAmount, cryptoAmount, currencyCode
    }
}

enum OrderStatuses: Int {
    
    case created = 1
    case submitted = 2
    case expired = 3
    case completed = 4
    
    var message: String {
        switch self {
        case .created:
            return ""
        case .submitted:
            return "Your order successfully submitted, waiting for the completion of the transaction (usually it takes 5-10 minutes)."
        case .expired:
            return "The time to submit the transaction has expired. You can no longer pay with this order, please go back to your merchant page and create a new transaction."
        case .completed:
            return "Your order successfully complited."
        }
    }
    
    var title: String {
        switch self {
        case .created:
            return ""
        case .submitted:
            return "Payment submitted"
        case .expired:
            return "Payment Expired"
        case .completed:
            return "Payment completed"
        }
    }
    
    var image: UIImage {
        switch self {
        case .created:
            return UIImage()
        case .submitted:
            return Images.submitted
        case .expired:
            return Images.expired
        case .completed:
            return Images.complited
        }
    }
}

