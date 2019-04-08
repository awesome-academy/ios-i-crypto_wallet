//
//  TokenList.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 3/29/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import ObjectMapper

final class TokenInfo: BaseModel {
    var balance = 0.0
    var name = ""
    var symbol = ""
    var usdPercentChange = 0.0
    var price = 0.0
    var decimals = 18.0
    var address = ""
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        balance <- map["balance"]
        name <- map["tokenInfo.name"]
        symbol <- map["tokenInfo.symbol"]
        usdPercentChange <- map["tokenInfo.price.diff"]
        price <- map["tokenInfo.price.rate"]
        decimals <- (map["tokenInfo.decimals"], DataTransform.StringDouble)
        address <- map["tokenInfo.address"]
    }
}
