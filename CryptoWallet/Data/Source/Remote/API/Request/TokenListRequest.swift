//
//  TokenListRequest.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/10/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

final class TokenListRequest: BaseRequest {
    required init(address: String) {
        let body: [String: Any] = [
            "apiKey": "freekey"
        ]
        super.init(url: "\(URLs.assetListAPI)/\(address)", requestType: .get, body: body)
    }
}
