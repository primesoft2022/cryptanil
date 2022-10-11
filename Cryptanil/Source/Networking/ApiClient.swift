//
//  ApiClient.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 03.10.22.
//

import Foundation

class ApiClient {
    static var base_url = "https://api.cryptanil.com/company/"
    
    static func getCoinAddress(parameter: GetCoinAddressRequest, isSilent: Bool = false, isErrorHandledInVc: Bool  = false, isCancelable: Bool = true, completion: @escaping(CoinAddress?, PrimeMessage?, PrimeError?) -> Void) {
        performRequest(route: Router.getCoinAddress(param: parameter),completion: completion, isSilent: isSilent, isErrorHandledInVc: isErrorHandledInVc, errorIsCancelabele: isCancelable)
    }
    
    static func getCryptanilOrderInfo(parameter: GetCryptanilOrderInfoRequest, isSilent: Bool = false, isErrorHandledInVc: Bool  = true, isCancelable: Bool = true, completion: @escaping(CryptanilOrderInfo?, PrimeMessage?, PrimeError?) -> Void) {
        performRequest(route: Router.getCryptanilOrderInfo(param: parameter),completion: completion, isSilent: isSilent, isErrorHandledInVc: isErrorHandledInVc, errorIsCancelabele: isCancelable)
    }
    
    static func getWalletInfo(parameter: GetWalletInfoRequest, isSilent: Bool = false, isErrorHandledInVc: Bool  = true, isCancelable: Bool = true, completion: @escaping([WalletInfo]?, PrimeMessage?, PrimeError?) -> Void) {
        performRequest(route: Router.getWalletInfo(param: parameter),completion: completion, isSilent: isSilent, isErrorHandledInVc: isErrorHandledInVc, errorIsCancelabele: isCancelable)
    }
    
    static func submitOrder(body: SubmitOrderRequest, isSilent: Bool = false, isErrorHandledInVc: Bool  = true, isCancelable: Bool = true, completion: @escaping(CryptanilOrderInfo?, PrimeMessage?, PrimeError?) -> Void) {
        performRequest(route: Router.submitOrder(body: body),completion: completion, isSilent: isSilent, isErrorHandledInVc: isErrorHandledInVc, errorIsCancelabele: isCancelable)
    }
}
