//
//  AssetMarketResponse.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/12/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import ObjectMapper

final class AssetMarketResponse: Mappable {
    var assetMarket: AssetMarket?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        assetMarket <- map["docs.0"]
    }
}
