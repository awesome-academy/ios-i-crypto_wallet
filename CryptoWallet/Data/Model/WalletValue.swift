//
//  WalletValueData.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/9/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import ObjectMapper

final class WalletValue: Mappable {
    var timeStamp = 0.0
    var totalUsd = 0.0
    
    required init(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        timeStamp <- (map["timestamp"], DataTransform.StringDouble)
        totalUsd <- (map["total_usd"], DataTransform.StringDouble)
    }
}
