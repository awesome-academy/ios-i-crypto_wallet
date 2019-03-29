//
//  Market.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/1/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import ObjectMapper

final class AssetMarket: BaseModel {
    var websiteSlug = ""
    var lastUpdated = 0.0
    var percentChange7d = 0.0
    var percentChange24h = 0.0
    var percentChange1h = 0.0
    var marketCap = 0.0
    var volume24h = 0.0
    var price = 0.0
    var totalSupply = 0.0
    var circulatingSupply = 0.0
    var rank = 0.0
    var symbol = ""
    var name = ""
    var id = 0
    var coin = 0
    var contract = ""
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        websiteSlug <- map["website_slug"]
        lastUpdated <- map["last_updated"]
        percentChange7d <- map["percent_change_7d"]
        percentChange24h <- map["percent_change_24h"]
        percentChange1h <- map["percent_change_1h"]
        marketCap <- map["market_cap"]
        volume24h <- map["volume_24h"]
        price <- map["price"]
        totalSupply <- map["total_supply"]
        circulatingSupply <- map["circulating_supply"]
        rank <- map["rank"]
        symbol <- map["symbol"]
        name <- map["name"]
        id <- map["id"]
        coin <- map["coin"]
        contract <- map["contract"]
    }
}
