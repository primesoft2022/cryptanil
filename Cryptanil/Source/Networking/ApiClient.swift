//
//  ApiClient.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 03.10.22.
//

import Foundation

class ApiClient {
    
    static var base_url = "https://api.cryptanil.com/"
    
    static func getCoinAddress(parameter: GetCoinAddressRequest,
                               isSilent: Bool = false,
                               completion: @escaping(CoinAddress?, CryptanilMessage?, CryptanilError?) -> Void,
                               cryptaninFailed: @escaping (CryptanilError) -> Void) {
        performRequest(route: Router.getCoinAddress(param: parameter), isSilent: isSilent, completion: completion, cryptaninFailed: cryptaninFailed)
    }
    
    static func getCryptanilOrderInfo(parameter: GetCryptanilOrderInfoRequest,
                                      isSilent: Bool = false,
                                      completion: @escaping(CryptanilOrderInfo?, CryptanilMessage?, CryptanilError?) -> Void,
                                      cryptaninFailed: @escaping (CryptanilError) -> Void) {
        performRequest(route: Router.getCryptanilOrderInfo(param: parameter), isSilent: isSilent, completion: completion, cryptaninFailed: cryptaninFailed)
    }
    
    static func getWalletInfo(parameter: GetWalletInfoRequest,
                              isSilent: Bool = false,
                              completion: @escaping([WalletInfo]?, CryptanilMessage?, CryptanilError?) -> Void,
                              cryptaninFailed: @escaping (CryptanilError) -> Void) {
        performRequest(route: Router.getWalletInfo(param: parameter), isSilent: isSilent, completion: completion, cryptaninFailed: cryptaninFailed)
    }
    
    static func submitOrder(body: SubmitOrderRequest,
                            isSilent: Bool = false,
                            completion: @escaping(CryptanilOrderInfo?, CryptanilMessage?, CryptanilError?) -> Void,
                            cryptaninFailed: @escaping (CryptanilError) -> Void) {
        performRequest(route: Router.submitOrder(body: body), isSilent: isSilent, completion: completion, cryptaninFailed: cryptaninFailed)
    }
}
