//
//  CronJobRequest.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/11/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

final class CronJobRequest: BaseRequest {
    required init(address: String) {
        let body: [String: Any] = [
            "title": address,
            "enabled": 1,
            "category": CronJobAPI.categoryGroupId,
            "plugin": "urlplug",
            "target": "allgrp",
            "timing": ["minutes": [ 0, 20, 40 ]],
            "params": ["url": "http://secretcat.spdns.org/wallet-tracker.php?address=\(address)"]
        ]
        super.init(url: URLs.cronJobAPI, requestType: .post, body: body)
    }
}
