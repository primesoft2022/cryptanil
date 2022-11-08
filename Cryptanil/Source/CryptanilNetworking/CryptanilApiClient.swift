//
//  ApiClient.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 03.10.22.
//

import Foundation

class CryptanilApiClient {
    
    static var base_url = "https://api.cryptanil.com/"
    
    static func getCoinAddress(parameter: GetCoinAddressRequest,
                               isSilent: Bool = false,
                               completion: @escaping(CoinAddress?, CryptanilMessage?, CryptanilError?) -> Void,
                               cryptaninFailed: @escaping (CryptanilError) -> Void) {
        performRequest(route: CryptanilRouter.getCoinAddress(param: parameter), isSilent: isSilent, completion: completion, cryptaninFailed: cryptaninFailed)
    }
    
    static func getCryptanilOrderInfo(parameter: GetCryptanilOrderInfoRequest,
                                      isSilent: Bool = false,
                                      completion: @escaping(CryptanilOrderInfo?, CryptanilMessage?, CryptanilError?) -> Void,
                                      cryptaninFailed: @escaping (CryptanilError) -> Void) {
        performRequest(route: CryptanilRouter.getCryptanilOrderInfo(param: parameter), isSilent: isSilent, completion: completion, cryptaninFailed: cryptaninFailed)
    }
    
    static func getWalletInfo(parameter: GetWalletInfoRequest,
                              isSilent: Bool = false,
                              completion: @escaping([WalletInfo]?, CryptanilMessage?, CryptanilError?) -> Void,
                              cryptaninFailed: @escaping (CryptanilError) -> Void) {
        performRequest(route: CryptanilRouter.getWalletInfo(param: parameter), isSilent: isSilent, completion: completion, cryptaninFailed: cryptaninFailed)
    }
    
    static func submitOrder(body: SubmitOrderRequest,
                            isSilent: Bool = false,
                            completion: @escaping(CryptanilOrderInfo?, CryptanilMessage?, CryptanilError?) -> Void,
                            cryptaninFailed: @escaping (CryptanilError) -> Void) {
        performRequest(route: CryptanilRouter.submitOrder(body: body), isSilent: isSilent, completion: completion, cryptaninFailed: cryptaninFailed)
    }
}
