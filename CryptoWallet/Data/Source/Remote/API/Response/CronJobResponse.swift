//
//  File.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/11/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import ObjectMapper

final class CronJobResponse: Mappable {
    var code = 0
    var id = ""
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        id <- map["id"]
    }
}
