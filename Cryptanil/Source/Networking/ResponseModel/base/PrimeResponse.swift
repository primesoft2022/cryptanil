//
//  PrimeResponse.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 03.10.22.
//

import Foundation

struct PrimeResponse<T:Codable>:Codable {
    var result: PrimeResult<T>?
    var error: PrimeError?
    
    func hasError() -> Bool{
        return error != nil
    }
}
