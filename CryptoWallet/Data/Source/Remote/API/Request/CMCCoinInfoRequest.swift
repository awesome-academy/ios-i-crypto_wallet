//
//  CMCCoinInfoRequest.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/10/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

final class CMCCoinInfoRequest: BaseRequest {
    required init() {
        super.init(url: URLs.cmcCoinInfoData, requestType: .get)
    }
}
