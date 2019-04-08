//
//  TransactionResponse.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/15/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

final class TransactionRequest: BaseRequest {
    required init(walletAddress: String, page: Int, contractAddress: String) {
        var body: [String: Any] = [
            "address": walletAddress,
            "page": page
        ]
        if !contractAddress.isEmpty {
            body["contract"] = contractAddress
        }
        print(body)
        super.init(url: URLs.transactionAPI, requestType: .get, body: body)
    }
}
