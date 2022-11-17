//
//  SubmitOrderResponse.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 04.10.22.
//

import Foundation

// MARK: - SubmitOrderResponse
@objc public class CryptanilOrderInfo: NSObject, Codable {
    var status: Int
    let orderID, convertedCoinType, redirectURL: String
    let isTesting: Bool
    let companyName: String
    let txID: String?
    let callBackFail: Bool
    let convertedAmountCurrency: Double?
    let convertedAmount: Double?
    let cryptoAmount: String?
    let currencyCode: String?
    let amountToShow: Double?
    let amountToShowCurrency: Double?
    let merchantCommission: Double?
    let merchantCommissionCurrency: Double?
    let depositCoinType: String?
    
    internal var convertedAmountToString: String? {
        if let convertedAmount = convertedAmount {
            return "\(convertedAmount)".cryptanilDouble() + " \(convertedCoinType)"
        }
        return nil
    }
    
    internal var convertedCurrencyToString: String? {
        if let convertedAmountCurrency = convertedAmountCurrency, let currencyCode = currencyCode {
            return "\(convertedAmountCurrency)".cryptanilDouble() + " \(currencyCode)"
        }
        return nil
    }
    
    internal var amountToShowString: String? {
        if let amountToShow = amountToShow {
            return "\(amountToShow)".cryptanilDouble() + " \(convertedCoinType)"
        }
        return nil
    }
    
    internal var amountToShowCurrencyString: String? {
        if let amountToShowCurrency = amountToShowCurrency, let currencyCode = currencyCode {
            return "\(amountToShowCurrency)".cryptanilDouble() + " \(currencyCode)"
        }
        return nil
    }
    
    internal var merchantCommissionString: String? {
        if let merchantCommission = merchantCommission, let depositCoinType = depositCoinType {
            return "\(merchantCommission)".cryptanilDouble() + " \(depositCoinType)"
        }
        return nil
    }
    
    internal var merchantCommissionCurrencyString: String? {
        if let merchantCommissionCurrency = merchantCommissionCurrency, let currencyCode = currencyCode {
            return "\(merchantCommissionCurrency)".cryptanilDouble() + " \(currencyCode)"
        }
        return nil
    }

    internal enum CodingKeys: String, CodingKey {
        case status
        case orderID = "orderId"
        case convertedCoinType
        case redirectURL = "redirectUrl"
        case isTesting, companyName
        case txID = "txId"
        case callBackFail, convertedAmountCurrency, convertedAmount, cryptoAmount, currencyCode, amountToShow, amountToShowCurrency, merchantCommission, merchantCommissionCurrency, depositCoinType
    }
}

@objc public enum CryptanilOrderStatus: Int {
    
    case created = 1
    case submitted = 2
    case expired = 3
    case completed = 4
    
    internal var message: String {
        switch self {
        case .created:
            return ""
        case .submitted:
            return "Your order successfully submitted, waiting for the completion of the transaction (usually it takes 5-10 minutes).".cryptanilLocalized()
        case .expired:
            return "The time to submit the transaction has expired. You can no longer pay with this order, please go back to your merchant page and create a new transaction.".cryptanilLocalized()
        case .completed:
            return "Your order successfully complited.".cryptanilLocalized()
        }
    }
    
    internal var title: String {
        switch self {
        case .created:
            return ""
        case .submitted:
            return "Payment submitted".cryptanilLocalized()
        case .expired:
            return "Payment Expired".cryptanilLocalized()
        case .completed:
            return "Payment completed".cryptanilLocalized()
        }
    }
    
    var image: UIImage {
        switch self {
        case .created:
            return UIImage()
        case .submitted:
            return CryptanilImages.submitted
        case .expired:
            return CryptanilImages.expired
        case .completed:
            return CryptanilImages.complited
        }
    }
}

