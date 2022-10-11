//
//  ApiClient+Execution.swift
//  Alamofire
//
//  Created by Hayk Movsesyan on 03.10.22.
//

import Foundation
import Alamofire

extension ApiClient {
    
    public static weak var loading: Loading!
    public static var loadingQueue = DispatchQueue(label: "loading_queue")
    
    public static func performRequest<T: Codable>(route: URLRequestConvertible, decoder: JSONDecoder = JSONDecoder(), completion: @escaping (T?, PrimeMessage?, PrimeError?) -> Void, isSilent: Bool = false, isErrorHandledInVc: Bool = false, showMessage: Bool = false, errorIsCancelabele: Bool = true)  {
        
        if Connectivity.isConnectedToInternet() {
            if !isSilent {
                increment()
                startLoading()
            }
            let request: DataRequest = Alamofire.request(route)
            request.responseJSONDecodable(decoder: decoder) { (response: DataResponse<PrimeResponse<T>>) in
                if !isSilent {
                    decrement()
                }
                switch response.result {
                case .failure(let error):
                    if !isSilent {
                        DispatchQueue.main.async {
                            if isErrorHandledInVc {
                                ApiClient.handleSwiftError(error)
                            }
                            completion(nil, nil, nil)
                            if counter == 0 && !isSilent {
                                stopLoading()
                            }
                        }
                    }
                case .success(let data):
                    DispatchQueue.main.async {
                        if data.hasError() {
                            completion(data.result?.data, data.result?.message, data.error)
                            if counter == 0 && !isSilent {
                                stopLoading()
                            }
                        } else {
                            if counter == 0 && !isSilent {
                                stopLoading(with: showMessage ? data.result?.message?.localizedMessage : nil)
                            }
                            completion(data.result?.data, data.result?.message, nil)
                        }
                    }
                }
            }
            request.validate()
        } else {
            stopLoading()
            Alamofire.SessionManager.default.session.getAllTasks { (tasks) in
                tasks.forEach{ $0.cancel() }
            }
            ApiClient.handleNoInternetConnection(isCancelable: errorIsCancelabele)
            completion(nil, nil, nil)
        }
    }
}

class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

