//
//  AssetInfo.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/5/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import UIKit

struct AssetInfo {
    var logo: UIImage?
    var name = ""
    var symbol = ""
    var price = 0.0
    var twentyFourHChange = 0.0
    var amount = 0.0
}

extension AssetInfo {
    static func mock() -> AssetInfo {
        return AssetInfo(logo: UIImage(named: "ethereum"),
                         name: "Ethereum",
                         symbol: "ETH",
                         price: 162.0,
                         twentyFourHChange: -2.45,
                         amount: 10)
    }
}
