//
//  swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 3/29/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import ObjectMapper

final class Contract: BaseModel {
    var contract = ""
    var address = ""
    var name = ""
    var decimals = 0.0
    var symbol = ""
    var coin = 0.0
    var type = ""
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        contract <- map["contract"]
        address <- map["address"]
        name <- map["name"]
        decimals <- map["decimals"]
        symbol <- map["symbol"]
        coin <- map["coin"]
        type <- map["type"]
    }
}
