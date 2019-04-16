//
//  CheckCronJobResponse.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/14/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import ObjectMapper

final class CheckCronJobResponse: Mappable {
    var code = ""
    var description = ""
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        description <- map["description"]
    }
}
