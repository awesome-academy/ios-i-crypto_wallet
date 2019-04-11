//
//  EthereumMarketResponse.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/10/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import ObjectMapper

final class EthereumMarketResponse: Mappable {
    var name = ""
    var usdPercentChange = 0.0
    var price = 0.0
    var symbol = ""
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        name <- map["docs.0.name"]
        symbol <- map["docs.0.symbol"]
        price <- map["docs.0.price"]
        usdPercentChange <- map["docs.0.percent_change_24h"]
    }
}
