//
//  TokenListResponse.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/10/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import ObjectMapper

final class TokenListResponse: Mappable {
    var etherBalance = 0.0
    var tokens: [TokenInfo]?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        etherBalance <- map["ETH.balance"]
        tokens <- map["tokens"]
    }
}
