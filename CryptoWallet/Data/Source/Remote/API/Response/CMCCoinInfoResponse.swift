//
//  CMCCoinInfoResponse.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/10/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import ObjectMapper

final class CMCCoinInfoResponse: Mappable {
    var name = ""
    var symbol = ""
    var id = 0
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        symbol <- map["symbol"]
        id <- map["id"]
    }
}
