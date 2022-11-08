//
//  ApiClient+Execution.swift
//  Alamofire
//
//  Created by Hayk Movsesyan on 03.10.22.
//

import Foundation
import Alamofire

extension CryptanilApiClient {
    
    internal static weak var loading: CryptanilLoading!
    internal static var loadingQueue = DispatchQueue(label: "loading_queue")
    private static var inMaintenance = false
    
    public static func performRequest<T: Codable>(route: URLRequestConvertible,
                                                  isSilent: Bool = false,
                                                  completion: @escaping (T?, CryptanilMessage?, CryptanilError?) -> Void,
                                                  cryptaninFailed: @escaping (CryptanilError) -> Void)  {
        
        if Connectivity.isConnectedToInternet() {
            if !isSilent {
                increment()
                startLoading()
            }
            let request: DataRequest = Alamofire.request(route)
            request.responseJSONDecodable(decoder: JSONDecoder()) { (response: DataResponse<CryptanilResponse<T>>) in
                if !isSilent {
                    decrement()
                }
                switch response.result {
                case .failure(let error):
                    checkMaintenance { failStatus in
                        switch failStatus {
                        case .undefined:
                            completion(nil, nil, CryptanilError.undefined)
                            handleUndefinedError {
                                cryptaninFailed(.undefined)
                            }
                        case .maintenance:
                            completion(nil, nil, CryptanilError.maintenance)
                            handleMaintenanceError {
                                cryptaninFailed(.maintenance)
                            }
                        case .endMaintenance:
                            performRequest(route: route, isSilent: isSilent, completion: completion, cryptaninFailed: cryptaninFailed)
                        }
                    }
                    DispatchQueue.main.async {
                        if counter == 0 && !isSilent {
                            stopLoading()
                        }
                    }
                case .success(let data):
                    DispatchQueue.main.async {
                        if data.hasError() {
                            handlePrimeError(data.error) {
                                cryptaninFailed(data.error!)
                            }
                            completion(data.result?.data, data.result?.message, data.error)
                            if counter == 0 && !isSilent {
                                stopLoading()
                            }
                        } else {
                            if counter == 0 && !isSilent {
                                stopLoading()
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
            CryptanilApiClient.handleNoInternetConnection { action in
                if action == .cancel {
                    cryptaninFailed(.noInternetConnection)
                    completion(nil, nil, CryptanilError.noInternetConnection)
                } else {
                    performRequest(route: route, isSilent: isSilent, completion: completion, cryptaninFailed: cryptaninFailed)
                }
            }
        }
    }
    
    private static func checkMaintenance(isSilent: Bool = false, completion: @escaping (FailStatus) -> Void) {
        
        if !isSilent {
            increment()
            startLoading()
        }
        let request: DataRequest = Alamofire.request(CryptanilRouter.checkMaintenance)
        request.responseJSONDecodable(decoder: JSONDecoder()) { (response: DataResponse<CryptanilResponse<Bool>>) in
            if !isSilent {
                decrement()
            }
            switch response.result {
            case .failure(_):
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    checkMaintenance(isSilent: true) { failStatus in
                        completion(failStatus)
                    }
                }
                inMaintenance = true
                completion(.maintenance)
            case .success(_):
                if inMaintenance {
                    if let window = UIApplication.shared.windows.first {
                        if let dialog = window.subviews.first(where: {$0 is CryptanilDialog}) as? CryptanilDialog {
                            switch dialog.dialogType {
                            case .underConstruction:
                                dialog.dismissDialog { }
                            default:
                                break
                            }
                        }
                    }
                    completion(.endMaintenance)
                } else {
                    completion(.undefined)
                }
                inMaintenance = false
            }
            if !isSilent && counter == 0 {
                DispatchQueue.main.async {
                    stopLoading()
                }
            }
        }
        request.validate()
    }
    
    enum FailStatus {
        case undefined
        case maintenance
        case endMaintenance
    }
}

class Connectivity {
    
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

