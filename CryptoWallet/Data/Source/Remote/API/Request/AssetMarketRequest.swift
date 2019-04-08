//
//  AssetMarketRequest.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/12/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

final class AssetMarketRequest: BaseRequest {
    required init(contractAddress: String) {
        let body: [String: Any] = [
            "contract": contractAddress
        ]
        super.init(url: URLs.assetMarketAPI, requestType: .get, body: body)
    }
}
