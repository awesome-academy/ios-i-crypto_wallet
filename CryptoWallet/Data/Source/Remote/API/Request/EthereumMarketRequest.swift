//
//  EthereumMarketRequest.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/10/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

final class EthereumMarketRequest: BaseRequest {
    required init() {
        let body: [String: Any] = [
            "coin_id": "60"
        ]
        super.init(url: URLs.assetMarketAPI, requestType: .get, body: body)
    }
}
