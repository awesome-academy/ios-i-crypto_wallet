//
//  WalletValueDataResponse.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/9/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import ObjectMapper

final class WalletValueDataResponse: Mappable {
    var totalUsd = 0.0
    var usdPercentChange = 0.0
    var history: [WalletValue]?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        usdPercentChange <- map["usd_percent_change"]
        totalUsd <- map["total_usd"]
        history <- map["history"]
    }
}
