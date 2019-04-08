//
//  WalletValueDataRequest.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/9/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

final class WalletValueDataRequest: BaseRequest {
    required init(address: String, from: Double) {
        let body: [String: Any] = [
            "address": address,
            "from": round(from)
        ]
        super.init(url: URLs.totalValueChartAPI, requestType: .get, body: body)
    }
}
