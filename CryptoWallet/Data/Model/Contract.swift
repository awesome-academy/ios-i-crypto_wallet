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
    var name = ""
    var decimals = 0.0
    var symbol = ""
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        contract <- map["contract"]
        name <- map["name"]
        decimals <- map["decimals"]
        symbol <- map["symbol"]
    }
}
