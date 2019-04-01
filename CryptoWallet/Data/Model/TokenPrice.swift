//
//  USDPrice.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 3/29/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import ObjectMapper

final class AssetPrice: BaseModel {
    var price = 0.0
    var percentChange24h = 0.0
    var contract = ""
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        price <- map["price"]
        percentChange24h <- map["percent_change_24h"]
        contract <- map["contract"]
    }
}
