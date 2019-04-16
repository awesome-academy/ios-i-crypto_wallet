//
//  CustomRequestAdapter.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/9/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import Alamofire

final class CustomRequestAdapter: RequestAdapter {
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        return urlRequest
    }
}

