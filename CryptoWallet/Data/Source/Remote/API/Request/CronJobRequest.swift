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
            "jobName": address,
            "user": "root",
            "command": "wget -q -O \"\(URLs.totalValueChartAPI)?address=\(address)\" > /dev/null 2>&1",
            "minute": "*/20",
            "hour": "*",
            "dayOfMonth": "*",
            "month": "*",
            "dayOfWeek": "*"
        ]
        super.init(url: URLs.baseUrl, requestType: .post, body: body)
    }
}
