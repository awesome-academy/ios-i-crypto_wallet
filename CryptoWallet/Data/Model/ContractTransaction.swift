//
//  ContractTransaction.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/1/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import ObjectMapper

final class ContractTransaction: BaseModel {
    var isVerified = false
    var isEnabled = false
    var address = ""
    var totalSupply = 0.0
    var decimals = 0
    var symbol = ""
    var name = ""
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        isVerified <- map["verified"]
        isEnabled <- map["enabled"]
        address <- map["address"]
        totalSupply <- map["totalSupply"]
        decimals <- map["decimals"]
        symbol <- map["symbol"]
        name <- map["name"]
    }
}
