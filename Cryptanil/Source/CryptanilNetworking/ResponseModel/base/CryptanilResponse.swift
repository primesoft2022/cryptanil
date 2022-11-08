//
//  PrimeResponse.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 03.10.22.
//

import Foundation

struct CryptanilResponse<T: Codable>: Codable {
    var result: CryptanilResult<T>?
    var error: CryptanilError?
    
    func hasError() -> Bool{
        return error != nil
    }
}
