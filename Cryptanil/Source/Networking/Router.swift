//
//  Router.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 03.10.22.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible{
    
    case getCoinAddress(param: GetCoinAddressRequest)
    case getCryptanilOrderInfo(param: GetCryptanilOrderInfoRequest)
    case getWalletInfo(param: GetWalletInfoRequest)
    case submitOrder(body: SubmitOrderRequest)
    case checkMaintenance
    
    var method: HTTPMethod {
        switch self {
        case .submitOrder:
            return .post
        default:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case  .getCoinAddress(let param):
            return "company/getCoinAddress" + param.parameters
        case .getCryptanilOrderInfo(let param):
            return "company/getCryptanilOrderInfo" + param.parameters
        case .getWalletInfo(let param):
            return "company/getWalletInfo" + param.parameters
        case .submitOrder:
            return "company/submitOrder"
        case .checkMaintenance:
            return "checkMaintenance"
        }
    }
    
    var body: Data? {
        switch self {
        case .submitOrder(let body):
            return body.jsonData()
        default:
            return nil
        }
    }
    
    func  asURLRequest() throws -> URLRequest {
        
        var url: URL
        var urlRequest: URLRequest
        let finalPath = ApiClient.base_url + path
        url = try (finalPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!).asURL()
        urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 80
        urlRequest.httpMethod = method.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("en", forHTTPHeaderField: "Language")
        if body != nil {
             urlRequest.httpBody = body
        }
        return urlRequest
    }
}
