//
//  CheckCronJobRequest.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/14/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation

import ObjectMapper
import Alamofire

final class CheckCronJobRequest: BaseRequest {
    required init(address: String) {
        let body: [String: Any] = [
            "title": address
        ]
        super.init(url: URLs.checkCronJobAPI, requestType: .post, body: body)
    }
}
